<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Sign Up</title>
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
        /* Smooth height transition for dynamic fields */
        .dynamic-field { transition: all 0.4s ease-in-out; overflow: hidden; }
        .hidden-field { max-height: 0; opacity: 0; margin-top: 0; }
        .visible-field { max-height: 300px; opacity: 1; margin-top: 1rem; }
    </style>
</head>
<body class="bg-slate-900 font-sans text-slate-200 min-h-screen flex items-center justify-center relative overflow-hidden py-10">
    
    <div class="absolute top-20 left-20 w-72 h-72 bg-blue-500 rounded-full mix-blend-screen filter blur-[100px] opacity-30 animate-blob"></div>
    <div class="absolute bottom-20 right-20 w-72 h-72 bg-purple-500 rounded-full mix-blend-screen filter blur-[100px] opacity-30 animate-blob animation-delay-2000"></div>

    <div class="relative z-10 w-full max-w-lg p-8 bg-white/10 backdrop-blur-xl rounded-3xl border border-white/20 shadow-2xl overflow-y-auto max-h-[90vh]">
        <div class="text-center mb-8">
            <h2 class="text-3xl font-black text-white tracking-tight">Create Account</h2>
            <p class="text-slate-400 mt-2 text-sm">Join the Rent4Student community</p>
        </div>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="bg-red-500/20 border border-red-500/50 text-red-200 p-3 rounded-lg mb-6 text-center text-sm font-bold backdrop-blur-sm">
                Registration failed. Email might already exist.
            </div>
        <% } %>

        <form action="auth" method="POST" class="flex flex-col gap-4">
            <input type="hidden" name="action" value="signup">
            
            <div>
                <label class="block text-slate-300 text-xs font-bold mb-1 uppercase tracking-wide">Register as a:</label>
                <select id="roleSelect" name="role" required onchange="toggleDynamicFields()" class="w-full bg-slate-800/50 border border-slate-600 text-white p-2.5 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all appearance-none">
                    <option value="student">Student</option>
                    <option value="owner">House Owner</option>
                </select>
            </div>

            <div>
                <label class="block text-slate-300 text-xs font-bold mb-1 uppercase tracking-wide">Full Name</label>
                <input type="text" name="fullName" required class="w-full bg-slate-800/50 border border-slate-600 text-white p-2.5 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none" placeholder="John Doe">
            </div>

            <div>
                <label class="block text-slate-300 text-xs font-bold mb-1 uppercase tracking-wide">Email</label>
                <input type="email" name="email" required class="w-full bg-slate-800/50 border border-slate-600 text-white p-2.5 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none" placeholder="Enter your email">
            </div>

            <div>
                <label class="block text-slate-300 text-xs font-bold mb-1 uppercase tracking-wide">Phone Number</label>
                <input type="text" name="phoneNumber" required class="w-full bg-slate-800/50 border border-slate-600 text-white p-2.5 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none" placeholder="01X-XXXXXXX">
            </div>
            
            <div>
                <label class="block text-slate-300 text-xs font-bold mb-1 uppercase tracking-wide">Password</label>
                <input type="password" name="password" required class="w-full bg-slate-800/50 border border-slate-600 text-white p-2.5 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none" placeholder="Create a password">
            </div>

            <div id="studentFields" class="dynamic-field visible-field grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-slate-300 text-xs font-bold mb-1 uppercase tracking-wide">University</label>
                    <input type="text" id="uniInput" name="university" class="w-full bg-slate-800/50 border border-slate-600 text-white p-2.5 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none" placeholder="e.g. UiTM">
                </div>
                <div>
                    <label class="block text-slate-300 text-xs font-bold mb-1 uppercase tracking-wide">Faculty</label>
                    <input type="text" id="facultyInput" name="faculty" class="w-full bg-slate-800/50 border border-slate-600 text-white p-2.5 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none" placeholder="e.g. FSKM">
                </div>
                <div class="col-span-2">
                    <label class="block text-slate-300 text-xs font-bold mb-1 uppercase tracking-wide">Preferred Location</label>
                    <input type="text" id="locationInput" name="preferredLocation" class="w-full bg-slate-800/50 border border-slate-600 text-white p-2.5 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none" placeholder="e.g. Shah Alam, Kuala Terengganu">
                </div>
            </div>
            
            <button type="submit" class="w-full bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-500 hover:to-orange-700 text-white font-bold py-3 px-4 rounded-xl mt-2 shadow-lg transition-all">
                Sign Up
            </button>
        </form>

        <p class="text-center text-sm text-slate-400 mt-6">
            Already have an account? <a href="login.jsp" class="text-orange-400 font-bold hover:underline transition">Log In</a>
        </p>
    </div>

    <script>
        function toggleDynamicFields() {
            const role = document.getElementById('roleSelect').value;
            const studentFields = document.getElementById('studentFields');
            const uniInput = document.getElementById('uniInput');
            const facultyInput = document.getElementById('facultyInput');
            const locationInput = document.getElementById('locationInput');

            if (role === 'student') {
                // Show Student Fields and make them required
                studentFields.classList.replace('hidden-field', 'visible-field');
                uniInput.required = true;
                facultyInput.required = true;
                locationInput.required = true;
            } else {
                // Hide Student Fields and make them NOT required so the form can submit
                studentFields.classList.replace('visible-field', 'hidden-field');
                uniInput.required = false;
                facultyInput.required = false;
                locationInput.required = false;
                uniInput.value = ''; 
                facultyInput.value = '';
                locationInput.value = '';
            }
        }
        // Run once on load just in case
        toggleDynamicFields();
    </script>
</body>
</html>