<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes blob {
            0% { transform: translate(0px, 0px) scale(1); }
            33% { transform: translate(30px, -50px) scale(1.1); }
            66% { transform: translate(-20px, 20px) scale(0.9); }
            100% { transform: translate(0px, 0px) scale(1); }
        }
        .animate-blob { animation: blob 7s infinite; }
        .animation-delay-2000 { animation-delay: 2s; }
        
        input[type="password"]::-ms-reveal,
        input[type="password"]::-ms-clear {
            display: none;
        }
    </style>
</head>
<body class="bg-slate-900 font-sans text-slate-200 min-h-screen flex items-center justify-center relative overflow-hidden">
    
    <div class="absolute top-20 left-20 w-72 h-72 bg-orange-500 rounded-full mix-blend-screen filter blur-[100px] opacity-30 animate-blob"></div>
    <div class="absolute bottom-20 right-20 w-72 h-72 bg-blue-500 rounded-full mix-blend-screen filter blur-[100px] opacity-30 animate-blob animation-delay-2000"></div>

    <div class="relative z-10 w-full max-w-md p-8 bg-white/10 backdrop-blur-xl rounded-3xl border border-white/20 shadow-2xl">
        <div class="text-center mb-8">
            <h2 class="text-3xl font-black text-white tracking-tight">Welcome Back</h2>
            <p class="text-slate-400 mt-2 text-sm">Sign in to your Rent4Student account</p>
        </div>
        
        <% if("invalid".equals(request.getParameter("error"))) { %>
            <div class="bg-red-500/20 border border-red-500/50 text-red-200 p-3 rounded-lg mb-6 text-center text-sm font-bold backdrop-blur-sm">
                Invalid Email, Password, or Role.
            </div>
        <% } %>
        
        <% if("registered".equals(request.getParameter("success"))) { %>
            <div class="bg-green-500/20 border border-green-500/50 text-green-200 p-3 rounded-lg mb-6 text-center text-sm font-bold backdrop-blur-sm">
                Account created! Please log in.
            </div>
        <% } %>

        <% if("appeal_sent".equals(request.getParameter("success"))) { %>
            <div class="bg-emerald-500/20 border border-emerald-500/50 text-emerald-200 p-3 rounded-lg mb-6 text-center text-sm font-bold backdrop-blur-sm">
                Appeal Sent Successfully. The root admin will review your ticket.
            </div>
        <% } %>

        <form action="auth" method="POST" class="flex flex-col gap-5" onsubmit="return validateRole()">
            <input type="hidden" name="action" value="login">
            
            <div class="relative group" id="custom-role-select">
                <label class="block text-slate-400 text-xs font-semibold mb-2 uppercase tracking-wider">I am a:</label>

                <input type="hidden" name="role" id="role-input">

                <button type="button" id="dropdown-button" class="w-full flex items-center justify-between bg-slate-800/80 border border-slate-700 text-slate-200 p-3.5 rounded-xl hover:bg-slate-800 hover:border-slate-500 focus:ring-2 focus:ring-orange-500 focus:border-orange-500 outline-none transition-all shadow-sm">
                    <span id="dropdown-text" class="text-slate-400">Select your role...</span>
                    <svg id="dropdown-arrow" class="w-4 h-4 text-slate-500 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                    </svg>
                </button>

                <div id="dropdown-menu" class="absolute z-50 w-full mt-2 bg-slate-800 border border-slate-700 rounded-2xl shadow-xl overflow-hidden opacity-0 invisible -translate-y-2 transition-all duration-200 ease-out">
                    <div class="py-1">
                        <div class="dropdown-option px-4 py-3 text-slate-200 hover:bg-slate-800 hover:text-orange-400 cursor-pointer transition-colors" data-value="student">Student</div>
                        <div class="dropdown-option px-4 py-3 text-slate-200 hover:bg-slate-800 hover:text-orange-400 cursor-pointer transition-colors" data-value="owner">House Owner</div>
                        <div class="dropdown-option px-4 py-3 text-slate-200 hover:bg-slate-800 hover:text-orange-400 cursor-pointer transition-colors" data-value="admin">System Admin</div>
                    </div>
                </div>
            </div>

            <div>
                <label class="block text-slate-300 text-xs font-bold mb-2 uppercase tracking-wide">Email</label>
                <input type="email" name="email" required class="w-full bg-slate-800/50 border border-slate-600 text-white placeholder-slate-500 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 focus:border-transparent outline-none transition-all" placeholder="Enter your email">
            </div>
            
            <div>
                <label class="block text-slate-300 text-xs font-bold mb-2 uppercase tracking-wide">Password</label>
                <div class="relative flex items-center">
                    <input type="password" id="passwordField" name="password" required class="w-full bg-slate-800/50 border border-slate-600 text-white placeholder-slate-500 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 focus:border-transparent outline-none transition-all pr-12" placeholder="Enter your password">
                    
                    <button type="button" onclick="togglePassword()" class="absolute right-4 text-slate-400 hover:text-orange-500 transition-colors focus:outline-none">
                        <svg id="eyeIcon" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                        </svg>
                    </button>
                </div>
            </div>
            
            <button type="submit" class="w-full bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold py-3 px-4 rounded-xl mt-4 shadow-lg shadow-orange-500/30 transform hover:-translate-y-0.5 transition-all duration-200">
                Sign In
            </button>
        </form>

        <p class="text-center text-sm text-slate-400 mt-6">
            Don't have an account? <a href="signup.jsp" class="text-orange-400 font-bold hover:text-orange-300 hover:underline transition">Sign Up</a>
        </p>
    </div>

    <% if("blocked".equals(request.getParameter("error"))) { %>
        <div class="fixed inset-0 bg-slate-950/80 backdrop-blur-md z-[100] flex items-center justify-center p-4">
            <div class="bg-slate-900 rounded-3xl shadow-2xl max-w-md w-full overflow-hidden border border-red-500/30">
                <div class="bg-red-500/10 p-6 text-center border-b border-red-500/20">
                    <div class="w-16 h-16 bg-red-500/20 text-red-500 rounded-full flex items-center justify-center mx-auto mb-3">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                    </div>
                    <h3 class="text-2xl font-black text-red-500 tracking-tight">Access Denied</h3>
                </div>
                <div class="p-8">
                    <p class="text-slate-300 text-center font-medium mb-6 leading-relaxed text-sm">You have been blocked by administrative access due to inappropriate behavior or violations of system policy.</p>
                    <form action="auth" method="POST" class="m-0">
                        <input type="hidden" name="action" value="submitAppeal">
                        <input type="hidden" name="username" value="<%= request.getParameter("username") %>">
                        <input type="hidden" name="role" value="<%= request.getParameter("role") %>">
                        <label class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Submit Appeal to Root Admin</label>
                        <textarea name="appealMessage" rows="3" required class="w-full bg-slate-800/50 border border-slate-700 text-white placeholder-slate-500 p-3 rounded-xl focus:ring-2 focus:ring-red-500 focus:border-transparent outline-none transition-all mb-6 text-sm resize-none" placeholder="Explain your situation and request account recovery..."></textarea>
                        <div class="flex gap-3">
                            <a href="login.jsp" class="w-1/3 bg-slate-800 hover:bg-slate-700 border border-slate-700 text-slate-300 font-bold py-3 rounded-xl text-center transition-colors text-sm flex items-center justify-center shadow-sm">Cancel</a>
                            <button type="submit" class="w-2/3 bg-red-600 hover:bg-red-700 text-white font-bold py-3 rounded-xl transition-colors shadow-lg shadow-red-900/50 text-sm">Send Appeal</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    <% } %>
        
    <script>
        function togglePassword() {
            const passInput = document.getElementById('passwordField');
            const eyeIcon = document.getElementById('eyeIcon');
            
            if (passInput.type === 'password') {
                passInput.type = 'text';
                eyeIcon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />';
            } else {
                passInput.type = 'password';
                eyeIcon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>';
            }
        }

        function validateRole() {
            const roleInput = document.getElementById('role-input').value;
            if (!roleInput) {
                const btn = document.getElementById('dropdown-button');
                const text = document.getElementById('dropdown-text');
                btn.classList.remove('border-slate-700');
                btn.classList.add('border-red-500', 'bg-red-500/10');
                text.classList.remove('text-slate-400');
                text.classList.add('text-red-400', 'font-bold');
                text.textContent = "Please select a role first!";
                return false;
            }
            return true;
        }

        document.addEventListener('DOMContentLoaded', () => {
            const button = document.getElementById('dropdown-button');
            const menu = document.getElementById('dropdown-menu');
            const arrow = document.getElementById('dropdown-arrow');
            const text = document.getElementById('dropdown-text');
            const hiddenInput = document.getElementById('role-input');
            const options = document.querySelectorAll('.dropdown-option');

            button.addEventListener('click', () => {
                menu.classList.toggle('opacity-0');
                menu.classList.toggle('invisible');
                menu.classList.toggle('-translate-y-2');
                arrow.classList.toggle('rotate-180');
            });

            options.forEach(option => {
                option.addEventListener('click', () => {
                    text.textContent = option.textContent;
                    text.classList.remove('text-slate-400', 'text-red-400', 'font-bold');
                    text.classList.add('text-slate-200');
                    button.classList.remove('border-red-500', 'bg-red-500/10');
                    button.classList.add('border-slate-700');
                    hiddenInput.value = option.getAttribute('data-value');
                    menu.classList.add('opacity-0', 'invisible', '-translate-y-2');
                    arrow.classList.remove('rotate-180');
                });
            });

            document.addEventListener('click', (e) => {
                if (!button.contains(e.target) && !menu.contains(e.target)) {
                    menu.classList.add('opacity-0', 'invisible', '-translate-y-2');
                    arrow.classList.remove('rotate-180');
                }
            });
        });
    </script>
</body>
</html>