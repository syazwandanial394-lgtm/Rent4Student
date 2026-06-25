<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole || sessionScope.userRole != 'owner'}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Upgrade to Premium</title>
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

        /* Processing Loader & Modal Animation Styles */
        .loader { border: 4px solid #f3f4f6; border-top: 4px solid #f97316; border-radius: 50%; width: 40px; height: 40px; animation: spin 1s linear infinite; margin: 0 auto; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .modal-enter { opacity: 0; transform: scale(0.95); transition: all 0.3s ease-out; }
        .modal-enter-active { opacity: 1; transform: scale(1); }
    </style>
</head>
<body class="bg-slate-900 font-sans text-slate-200 min-h-screen flex items-center justify-center relative overflow-hidden">
    
    <div class="absolute top-20 left-20 w-72 h-72 bg-orange-500 rounded-full mix-blend-screen filter blur-[100px] opacity-30 animate-blob"></div>
    <div class="absolute bottom-20 right-20 w-72 h-72 bg-blue-500 rounded-full mix-blend-screen filter blur-[100px] opacity-30 animate-blob animation-delay-2000"></div>

    <div class="relative z-10 w-full max-w-lg p-8 bg-white/10 backdrop-blur-xl rounded-3xl border border-white/20 shadow-2xl">
        
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-orange-500/20 mb-4 border border-orange-500/50 shadow-[0_0_15px_rgba(249,115,22,0.3)]">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-orange-400" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path>
                </svg>
            </div>
            <h2 class="text-3xl font-black text-white tracking-tight">Limit Reached</h2>
            <p class="text-slate-400 mt-2 text-sm">You have reached your limit of 5 free properties.</p>
        </div>
        
        <div class="bg-slate-800/50 border border-slate-600 rounded-2xl p-6 mb-8 text-center relative overflow-hidden">
            <div class="absolute top-0 inset-x-0 h-1 bg-gradient-to-r from-orange-400 to-orange-600"></div>
            
            <h3 class="text-xl font-bold text-white mb-2">Premium Owner Plan</h3>
            <div class="text-orange-400 font-black text-4xl mb-4 tracking-tight">RM 49<span class="text-lg text-slate-400 font-normal">/mo</span></div>
            
            <ul class="text-left text-sm text-slate-300 space-y-3 mb-2 flex flex-col items-center">
                <li class="flex items-center gap-3 w-48">
                    <svg class="w-5 h-5 text-green-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                    Unlimited Properties
                </li>
                <li class="flex items-center gap-3 w-48">
                    <svg class="w-5 h-5 text-green-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                    Priority Support
                </li>
                <li class="flex items-center gap-3 w-48">
                    <svg class="w-5 h-5 text-green-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                    Featured Listings
                </li>
            </ul>
        </div>

        <form id="subscriptionForm" action="subscriptionController" method="POST" class="flex flex-col gap-4">
            <input type="hidden" name="action" value="subscribe">
            <input type="hidden" name="hoId" value="${sessionScope.loggedUser.hoId}">
            
            <button type="button" onclick="startUpgradeSimulation()" class="w-full bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold py-4 px-4 rounded-xl shadow-lg shadow-orange-500/30 transform hover:-translate-y-0.5 transition-all duration-200 outline-none">
                Upgrade Now
            </button>
            
            <a href="properties" class="text-center w-full bg-slate-800/50 hover:bg-slate-700/50 border border-slate-600 text-slate-300 font-bold py-3 px-4 rounded-xl transition-all duration-200">
                Cancel
            </a>
        </form>

    </div>

    <div id="processingModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center">
        <div class="absolute inset-0 bg-slate-950/80 backdrop-blur-md"></div>
        <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-10 w-full max-w-sm text-center text-slate-800 modal-enter" id="processingContent">
            <div class="loader mb-6"></div>
            <h2 class="text-2xl font-black text-slate-900 tracking-tight mb-2">Processing Upgrade</h2>
            <p class="text-slate-500 text-sm">Please do not close or refresh this window.<br>Connecting to secure sandbox gateway...</p>
        </div>
    </div>

    <script>
        function startUpgradeSimulation() {
            // Un-hide modal structure
            document.getElementById('processingModal').classList.remove('hidden');
            
            // Pop active styling transitions slightly after display configuration maps
            setTimeout(() => { 
                document.getElementById('processingContent').classList.add('modal-enter-active'); 
            }, 10);
            
            // Wait exactly 2000 milliseconds (2 seconds) then submit payload to Servlet
            setTimeout(() => { 
                document.getElementById('subscriptionForm').submit(); 
            }, 2000);
        }
    </script>
</body>
</html>