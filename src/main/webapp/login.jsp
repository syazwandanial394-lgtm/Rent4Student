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
        
        <% if(request.getParameter("error") != null) { %>
            <div class="bg-red-500/20 border border-red-500/50 text-red-200 p-3 rounded-lg mb-6 text-center text-sm font-bold backdrop-blur-sm">
                Invalid Email or Password.
            </div>
        <% } %>
        
        <% if(request.getParameter("success") != null) { %>
            <div class="bg-green-500/20 border border-green-500/50 text-green-200 p-3 rounded-lg mb-6 text-center text-sm font-bold backdrop-blur-sm">
                Account created! Please log in.
            </div>
        <% } %>

        <form action="auth" method="POST" class="flex flex-col gap-5">
            <input type="hidden" name="action" value="login">
            
            <div>
                <label class="block text-slate-300 text-xs font-bold mb-2 uppercase tracking-wide">I am a:</label>
                <select name="role" required class="w-full bg-slate-800/50 border border-slate-600 text-white p-3 rounded-xl focus:ring-2 focus:ring-orange-500 focus:border-transparent outline-none transition-all appearance-none">
                    <option value="student">Student</option>
                    <option value="owner">House Owner</option>
                    <option value="admin">System Admin</option>
                </select>
            </div>

            <div>
                <label class="block text-slate-300 text-xs font-bold mb-2 uppercase tracking-wide">Email</label>
                <input type="email" name="email" required class="w-full bg-slate-800/50 border border-slate-600 text-white placeholder-slate-500 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 focus:border-transparent outline-none transition-all" placeholder="Enter your email">
            </div>
            
            <div>
                <label class="block text-slate-300 text-xs font-bold mb-2 uppercase tracking-wide">Password</label>
                <input type="password" name="password" required class="w-full bg-slate-800/50 border border-slate-600 text-white placeholder-slate-500 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 focus:border-transparent outline-none transition-all" placeholder="Enter your password">
            </div>
            
            <button type="submit" class="w-full bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold py-3 px-4 rounded-xl mt-4 shadow-lg shadow-orange-500/30 transform hover:-translate-y-0.5 transition-all duration-200">
                Sign In
            </button>
        </form>

        <p class="text-center text-sm text-slate-400 mt-6">
            Don't have an account? <a href="signup.jsp" class="text-orange-400 font-bold hover:text-orange-300 hover:underline transition">Sign Up</a>
        </p>
    </div>
</body>
</html>