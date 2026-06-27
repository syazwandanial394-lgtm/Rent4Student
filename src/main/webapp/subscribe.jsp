<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole || sessionScope.userRole != 'owner'}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Manage Subscription</title>
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
        .loader { border: 4px solid #1e293b; border-top: 4px solid #f97316; border-radius: 50%; width: 40px; height: 40px; animation: spin 1s linear infinite; margin: 0 auto; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .modal-enter { opacity: 0; transform: scale(0.95); transition: all 0.3s ease-out; }
        .modal-enter-active { opacity: 1; transform: scale(1); }
    </style>
</head>
<body class="bg-slate-900 font-sans text-slate-200 min-h-screen flex items-center justify-center relative overflow-x-hidden overflow-y-auto py-12">
    
    <div class="fixed top-20 left-20 w-72 h-72 bg-orange-500 rounded-full mix-blend-screen filter blur-[100px] opacity-30 animate-blob pointer-events-none"></div>
    <div class="fixed bottom-20 right-20 w-72 h-72 bg-blue-500 rounded-full mix-blend-screen filter blur-[100px] opacity-30 animate-blob animation-delay-2000 pointer-events-none"></div>
    
    <c:set var="currentSub" value="${sessionScope.loggedUser.subscriptionStatus}" />

    <div class="relative z-10 max-w-7xl mx-auto w-full px-6 py-12">
        
        <div class="text-center mb-12">
            <h1 class="text-4xl font-black text-white tracking-tight">Manage Subscription</h1>
            <p class="text-slate-400 mt-2">You are currently on the <strong class="text-orange-400 uppercase tracking-widest text-xs">${currentSub}</strong> plan.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-10 max-w-6xl mx-auto">
            
            <!--STANDARD-->
            <div class="w-full p-8 bg-white/10 backdrop-blur-xl rounded-3xl border ${currentSub == 'Standard' ? 'border-orange-500 shadow-orange-500/20 shadow-2xl scale-105' : 'border-white/20 shadow-xl'} transition-all flex flex-col">
                <div class="text-center mb-8">
                    <div class="inline-flex items-center justify-center w-16 h-16 rounded-full border border-white mb-4">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-white" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path></svg>
                    </div>
                    <h2 class="text-3xl font-black text-white tracking-tight">Standard</h2>
                    <p class="text-slate-400 mt-2 text-sm">Upgrade to limit of 2 properties</p>
                </div>
                
                <div class="bg-slate-800/50 border border-slate-600 rounded-2xl p-6 mb-8 text-center relative overflow-hidden flex-grow">
                    <div class="absolute top-0 inset-x-0 h-1 bg-slate-600"></div>
                    <h3 class="text-xl font-bold text-white mb-2">Standard Plan</h3>
                    <div class="text-orange-400 font-black text-4xl mb-4 tracking-tight">RM 59.99<span class="text-lg text-slate-400 font-normal">/mo</span></div>
                    <ul class="text-left text-sm text-slate-300 space-y-3 mb-2 flex flex-col items-center">
                        <li class="flex items-center gap-3 w-48"><svg class="w-5 h-5 text-green-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> Up to 2 Properties</li>
                        <li class="flex items-center gap-3 w-48"><svg class="w-5 h-5 text-gray-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 6l12 12M18 6L6 18"></path></svg> Priority Support</li>
                        <li class="flex items-center gap-3 w-48"><svg class="w-5 h-5 text-gray-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 6l12 12M18 6L6 18"></path></svg> Featured Listings</li>
                    </ul>
                </div>

                <form id="formStandard" action="subscriptionController" method="POST" class="m-0 mt-auto">
                    <input type="hidden" name="action" value="standard">
                    <input type="hidden" name="hoId" value="${sessionScope.loggedUser.hoId}">
                    
                    <c:choose>
                        <c:when test="${currentSub == 'Standard'}">
                            <button type="button" disabled class="w-full bg-slate-800 border border-slate-600 text-slate-400 font-bold py-4 px-4 rounded-xl cursor-not-allowed">Current Plan</button>
                        </c:when>
                        <c:when test="${currentSub == 'Pro' || currentSub == 'Premium'}">
                            <button type="button" onclick="processSubscription('formStandard', 'Downgrading to Standard...')" class="w-full bg-slate-200 hover:bg-white text-slate-900 font-bold py-4 px-4 rounded-xl transition-all duration-200 shadow-lg">Downgrade</button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" onclick="processSubscription('formStandard', 'Upgrading to Standard...')" class="w-full bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold py-4 px-4 rounded-xl shadow-lg shadow-orange-500/30 transform hover:-translate-y-0.5 transition-all duration-200">Upgrade Now</button>
                        </c:otherwise>
                    </c:choose>
                </form>
            </div>
                
            <!--PRO-->
            <div class="w-full p-8 bg-white/10 backdrop-blur-xl rounded-3xl border ${currentSub == 'Pro' ? 'border-orange-500 shadow-orange-500/20 shadow-2xl scale-105' : 'border-white/20 shadow-xl'} transition-all flex flex-col">
                <div class="text-center mb-8">
                    <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-gradient-to-br from-gray-100 via-gray-300 to-gray-500 mb-4 border border-gray-500/50 shadow-[0_0_15px_rgba(192,192,192,0.35)]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-slate-400" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path></svg>
                    </div>
                    <h2 class="text-3xl font-black text-white tracking-tight">Pro</h2>
                    <p class="text-slate-400 mt-2 text-sm">Up to 3 properties!</p>
                </div>
                
                <div class="bg-slate-800/50 border border-slate-600 rounded-2xl p-6 mb-8 text-center relative overflow-hidden flex-grow">
                    <div class="absolute top-0 inset-x-0 h-1 bg-gradient-to-br from-gray-100 to-gray-500"></div>
                    <h3 class="text-xl font-bold text-white mb-2">Pro Plan</h3>
                    <div class="text-orange-400 font-black text-4xl mb-4 tracking-tight">RM 79.99<span class="text-lg text-slate-400 font-normal">/mo</span></div>
                    <ul class="text-left text-sm text-slate-300 space-y-3 mb-2 flex flex-col items-center">
                        <li class="flex items-center gap-3 w-48"><svg class="w-5 h-5 text-green-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> Up to 3 Properties!</li>
                        <li class="flex items-center gap-3 w-48"><svg class="w-5 h-5 text-green-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> Priority Support</li>
                        <li class="flex items-center gap-3 w-48"><svg class="w-5 h-5 text-gray-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 6l12 12M18 6L6 18"></path></svg> Featured Listings</li>
                    </ul>
                </div>

                <form id="formPro" action="subscriptionController" method="POST" class="m-0 mt-auto">
                    <input type="hidden" name="action" value="pro">
                    <input type="hidden" name="hoId" value="${sessionScope.loggedUser.hoId}">
                    
                    <c:choose>
                        <c:when test="${currentSub == 'Pro'}">
                            <button type="button" disabled class="w-full bg-slate-800 border border-slate-600 text-slate-400 font-bold py-4 px-4 rounded-xl cursor-not-allowed">Current Plan</button>
                        </c:when>
                        <c:when test="${currentSub == 'Premium'}">
                            <button type="button" onclick="processSubscription('formPro', 'Downgrading to Pro...')" class="w-full bg-slate-200 hover:bg-white text-slate-900 font-bold py-4 px-4 rounded-xl transition-all duration-200 shadow-lg">Downgrade</button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" onclick="processSubscription('formPro', 'Upgrading to Pro...')" class="w-full bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold py-4 px-4 rounded-xl shadow-lg shadow-orange-500/30 transform hover:-translate-y-0.5 transition-all duration-200">Upgrade Now</button>
                        </c:otherwise>
                    </c:choose>
                </form>
            </div>
            
            <!--PREMIUM-->
            <div class="w-full p-8 bg-white/10 backdrop-blur-xl rounded-3xl border ${currentSub == 'Premium' ? 'border-orange-500 shadow-orange-500/20 shadow-2xl scale-105' : 'border-white/20 shadow-xl'} transition-all flex flex-col">
                <div class="text-center mb-8">
                    <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-orange-500/20 mb-4 border border-orange-500/50 shadow-[0_0_15px_rgba(249,115,22,0.3)]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-orange-400" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path></svg>
                    </div>
                    <h2 class="text-3xl font-black text-white tracking-tight">Premium</h2>
                    <p class="text-slate-400 mt-2 text-sm">No limit!</p>
                </div>
                
                <div class="bg-slate-800/50 border border-slate-600 rounded-2xl p-6 mb-8 text-center relative overflow-hidden flex-grow">
                    <div class="absolute top-0 inset-x-0 h-1 bg-gradient-to-r from-orange-400 to-orange-600"></div>
                    <h3 class="text-xl font-bold text-white mb-2">Premium Plan</h3>
                    <div class="text-orange-400 font-black text-4xl mb-4 tracking-tight">RM 129.99<span class="text-lg text-slate-400 font-normal">/mo</span></div>
                    <ul class="text-left text-sm text-slate-300 space-y-3 mb-2 flex flex-col items-center">
                        <li class="flex items-center gap-3 w-48"><svg class="w-5 h-5 text-green-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> Unlimited Properties</li>
                        <li class="flex items-center gap-3 w-48"><svg class="w-5 h-5 text-green-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> Priority Support</li>
                        <li class="flex items-center gap-3 w-48"><svg class="w-5 h-5 text-green-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> Featured Listings</li>
                    </ul>
                </div>

                <form id="formPremium" action="subscriptionController" method="POST" class="m-0 mt-auto">
                    <input type="hidden" name="action" value="premium">
                    <input type="hidden" name="hoId" value="${sessionScope.loggedUser.hoId}">
                    
                    <c:choose>
                        <c:when test="${currentSub == 'Premium'}">
                            <button type="button" disabled class="w-full bg-slate-800 border border-slate-600 text-slate-400 font-bold py-4 px-4 rounded-xl cursor-not-allowed">Current Plan</button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" onclick="processSubscription('formPremium', 'Upgrading to Premium...')" class="w-full bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold py-4 px-4 rounded-xl shadow-lg shadow-orange-500/30 transform hover:-translate-y-0.5 transition-all duration-200">Upgrade Now</button>
                        </c:otherwise>
                    </c:choose>
                </form>
            </div>

        </div>

        <!-- Global Action Buttons -->
        <div class="flex flex-col sm:flex-row justify-center items-center gap-4 mt-12 max-w-3xl mx-auto">
            <a href="properties" class="w-full sm:w-64 text-center bg-slate-800/80 hover:bg-slate-700/80 border border-slate-600 text-slate-300 font-bold py-3.5 px-4 rounded-xl transition-all duration-200">
                Return to Properties
            </a>
            
            <c:if test="${currentSub != 'Free'}">
                <form id="formCancel" action="subscriptionController" method="POST" class="w-full sm:w-64 m-0">
                    <input type="hidden" name="action" value="free">
                    <input type="hidden" name="hoId" value="${sessionScope.loggedUser.hoId}">
                    
                    <!-- FIX: Opens the custom modal instead of the browser confirm() -->
                    <button type="button" onclick="openCancelModal()" class="w-full text-center bg-red-500/10 hover:bg-red-500/20 border border-red-500/50 text-red-400 font-bold py-3.5 px-4 rounded-xl transition-all duration-200">
                        Cancel Subscription
                    </button>
                </form>
            </c:if>
        </div>

    </div>

    <!-- CUSTOM CANCEL CONFIRMATION MODAL -->
    <div id="cancelModal" class="fixed inset-0 z-[120] hidden flex items-center justify-center p-4">
        <div class="absolute inset-0 bg-slate-950/80 backdrop-blur-md" onclick="closeCancelModal()"></div>
        <div class="relative bg-slate-800 rounded-3xl border border-slate-700 shadow-2xl p-8 w-full max-w-sm text-center modal-enter" id="cancelContent">
            
            <div class="w-16 h-16 bg-red-500/10 text-red-500 rounded-full flex items-center justify-center mx-auto mb-4 border border-red-500/30 shadow-[0_0_15px_rgba(239,68,68,0.2)]">
                <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
            </div>
            
            <h3 class="text-2xl font-black text-white mb-2">Cancel Plan?</h3>
            <p class="text-slate-400 text-sm mb-8 leading-relaxed">Are you sure you want to cancel? Your property limit will be immediately reduced to 1. Excess active listings may be hidden.</p>

            <div class="flex gap-3">
                <button type="button" onclick="closeCancelModal()" class="flex-1 bg-slate-700 hover:bg-slate-600 text-slate-200 font-bold py-3 rounded-xl transition-colors text-sm border border-slate-600">Keep Plan</button>
                <button type="button" onclick="confirmCancel()" class="flex-1 bg-red-600 hover:bg-red-500 text-white font-bold py-3 rounded-xl shadow-lg shadow-red-600/30 transition-all text-sm">Yes, Cancel</button>
            </div>
        </div>
    </div>
        
    <!--SIMULATE PAYMENT / LOADING -->        
    <div id="processingModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center p-4">
        <div class="absolute inset-0 bg-slate-950/80 backdrop-blur-md"></div>
        <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-10 w-full max-w-sm text-center text-slate-800 modal-enter" id="processingContent">
            <div class="loader mb-6"></div>
            <h2 id="processTitle" class="text-2xl font-black text-slate-900 tracking-tight mb-2">Processing...</h2>
            <p class="text-slate-500 text-sm">Please do not close or refresh this window.<br>Connecting to secure sandbox gateway...</p>
        </div>
    </div>

    <script>
        function processSubscription(formId, processMessage) {
            document.getElementById('processTitle').innerText = processMessage;
            document.getElementById('processingModal').classList.remove('hidden');
            
            setTimeout(() => { 
                document.getElementById('processingContent').classList.add('modal-enter-active'); 
            }, 10);
            
            setTimeout(() => { 
                document.getElementById(formId).submit(); 
            }, 2000);
        }

        // Custom Cancel Modal Logic
        function openCancelModal() {
            document.getElementById('cancelModal').classList.remove('hidden');
            setTimeout(() => { document.getElementById('cancelContent').classList.add('modal-enter-active'); }, 10);
        }

        function closeCancelModal() {
            document.getElementById('cancelContent').classList.remove('modal-enter-active');
            setTimeout(() => { document.getElementById('cancelModal').classList.add('hidden'); }, 300);
        }

        function confirmCancel() {
            closeCancelModal();
            // Wait slightly for the modal animation to finish before launching the loading screen
            setTimeout(() => {
                processSubscription('formFree', 'Canceling Subscription...');
            }, 300);
        }
    </script>
</body>
</html>