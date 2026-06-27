<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole}">
    <c:redirect url="login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Revenue Ledger</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes blob { 0% { transform: translate(0px, 0px) scale(1); } 33% { transform: translate(30px, -50px) scale(1.1); } 66% { transform: translate(-20px, 20px) scale(0.9); } 100% { transform: translate(0px, 0px) scale(1); } }
        .animate-blob { animation: blob 7s infinite; }
        
        @media print {
            @page { size: landscape; margin: 1cm; }
            
            body, main, .overflow-x-auto { overflow: visible !important; display: block !important; }
            
            nav, .animate-blob, #profileDrawer, #profileBackdrop, .print-hide { display: none !important; }
            
            table { width: 100% !important; border-collapse: collapse !important; font-size: 12pt !important; }
            th, td { padding: 12px 8px !important; white-space: normal !important; border-bottom: 1px solid #e2e8f0 !important; }
            .bg-slate-50 { background-color: #f8fafc !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            .shadow-sm { box-shadow: none !important; border: 1px solid #e2e8f0 !important; }
            
            main { max-width: 100% !important; padding: 0 !important; margin: 0 !important; }
        }
    </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen relative overflow-x-hidden overflow-y-scroll">
    <div class="absolute top-0 left-20 w-96 h-96 bg-orange-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob pointer-events-none z-0"></div>

    <!-- Navigation -->
    <nav class="bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-50 shadow-sm relative z-[60]">
        <div class="max-w-7xl mx-auto px-6 py-3 flex justify-between items-center">
            <div class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-orange-500" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72l5 2.73 5-2.73v3.72z"/></svg>
                <h1 class="text-2xl font-black text-slate-900 tracking-tight">Rent<span class="text-orange-500">4</span>Student</h1>
            </div>
            <div class="hidden md:flex gap-6 text-sm font-bold text-slate-600">
                <a href="dashboard" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Dashboard</a>
                <a href="properties" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Properties</a>
                <a href="applicationController" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Applications</a>
                <a href="rentalController" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Rentals</a>
                <a href="paymentController" class="text-orange-500 border-b-2 border-orange-500 pb-1">Revenue</a>
            </div>
            <div class="flex items-center gap-2">
                <div class="hidden md:block text-right mr-2">
                    <p class="text-xs text-slate-400 font-bold uppercase tracking-wider mb-0.5">Welcome,</p>
                    <p class="text-sm font-black text-slate-800 leading-none">${sessionScope.loggedUser.username}</p>
                </div>
                <button onclick="toggleProfileDrawer()" class="w-10 h-10 rounded-full bg-gradient-to-tr from-orange-400 to-orange-500 text-white font-black flex items-center justify-center shadow-md hover:shadow-lg hover:scale-105 transition-all outline-none focus:ring-4 focus:ring-orange-200 shrink-0 border-2 border-white overflow-hidden">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedUser.profileImage}"><img src="${sessionScope.loggedUser.profileImage}" class="w-full h-full object-cover" alt="Profile"></c:when>
                        <c:otherwise>${sessionScope.loggedUser.fullName.substring(0,1).toUpperCase()}</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-6 py-12 relative z-10">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-8 gap-4">
            <div>
                <h2 class="text-3xl font-extrabold text-slate-900">Revenue Ledger</h2>
                <p class="text-slate-500 mt-1">Track your incoming rent payments and official receipts.</p>
            </div>
            <button onclick="window.print()" class="print-hide bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-500 hover:to-blue-600 text-white font-bold py-3 px-6 rounded-xl shadow-lg transition-all flex items-center gap-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg> Print to PDF
            </button>
        </div>

        <div class="bg-white rounded-3xl shadow-sm border border-slate-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse min-w-[800px]">
                    <thead>
                        <tr class="bg-slate-50 border-b border-slate-100 text-xs font-black text-slate-500 uppercase tracking-wider">
                            <th class="p-6">Receipt ID</th>
                            <th class="p-6">Issue Date</th>
                            <th class="p-6">Payment Ref #</th>
                            <th class="p-6">Method</th>
                            <th class="p-6">Amount Received</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        <c:forEach items="${receiptList}" var="rec">
                            <tr class="hover:bg-slate-50/50 transition-colors">
                                <td class="p-6 font-bold text-slate-900 whitespace-nowrap">RCPT-${rec.receiptId}</td>
                                <td class="p-6 text-slate-600">${rec.issueDate}</td>
                                <td class="p-6 text-slate-500">PAY-${rec.paymentId}</td>
                                <td class="p-6 text-slate-600">${rec.paymentMethod}</td>
                                <td class="p-6 font-black text-green-600 whitespace-nowrap">RM ${rec.amountPaid}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty receiptList}">
                            <tr>
                                <td colspan="5" class="p-12 text-center text-slate-500 font-bold">
                                    <svg class="w-12 h-12 text-slate-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                                    No revenue history found.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- PROFILE DRAWER -->
    <div id="profileBackdrop" onclick="toggleProfileDrawer()" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-[100] hidden opacity-0 transition-opacity duration-300 print-hide"></div>
    <div id="profileDrawer" class="fixed top-0 right-0 h-full w-80 bg-white shadow-2xl z-[101] transform translate-x-full transition-transform duration-300 ease-in-out flex flex-col border-l border-slate-100 print-hide">
        <div class="p-6 bg-slate-50 border-b border-slate-100 flex justify-between items-start">
            <div class="flex items-center gap-4">
                <div class="w-14 h-14 rounded-full bg-orange-100 text-orange-600 font-black flex items-center justify-center text-2xl shadow-inner overflow-hidden border-2 border-white">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedUser.profileImage}"><img src="${sessionScope.loggedUser.profileImage}" class="w-full h-full object-cover" alt="Profile"></c:when>
                        <c:otherwise>${sessionScope.loggedUser.fullName.substring(0,1).toUpperCase()}</c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <p class="font-bold text-slate-900 leading-tight">${sessionScope.loggedUser.fullName}</p>
                    <p class="text-xs font-bold text-orange-500 uppercase tracking-widest mt-1">${sessionScope.userRole}</p>
                </div>
            </div>
            <button onclick="toggleProfileDrawer()" class="text-slate-400 hover:text-red-500 transition-colors bg-white rounded-full p-1 shadow-sm"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>
        </div>
        
        <div class="p-4 flex-1 flex flex-col gap-2 overflow-y-auto">
            <c:choose >
                <c:when test="${sessionScope.userRole == 'owner' and sessionScope.loggedUser.subscriptionStatus == 'Premium'}">
                    <div class="inline-flex items-center gap-3 px-6 py-3.5 bg-gradient-to-r from-yellow-500 via-amber-400 to-yellow-600 text-slate-950 font-black rounded-2xl uppercase tracking-wider text-xs shadow-xl shadow-amber-500/20 border border-yellow-300/40 transform transition-all duration-200">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-slate-950" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path>
                        </svg>
                        Premium Owner Unlocked
                    </div>
                </c:when>
                <c:when test="${sessionScope.userRole == 'owner' and sessionScope.loggedUser.subscriptionStatus == 'Pro'}">
                    <div class="inline-flex items-center gap-3 px-6 py-3.5 bg-gradient-to-r from-gray-100 via-gray-300 to-gray-600 text-slate-950 font-white rounded-2xl uppercase tracking-wider text-xs shadow-xl shadow-silver-500/20 border border-yellow-300/40 transform transition-all duration-200">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-slate-950" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path>
                        </svg>
                        Pro Owner Unlocked
                    </div>
                </c:when>
                <c:when test="${sessionScope.userRole == 'owner' and sessionScope.loggedUser.subscriptionStatus == 'Standard'}">
                    <div class="inline-flex items-center gap-3 px-6 py-3.5 bg-gradient-to-r from-gray-200 via-glate-800 to-gray-200 text-slate-950 font-black rounded-2xl uppercase tracking-wider text-xs shadow-xl shadow-slate-500/20 border border-yellow-300/40 transform transition-all duration-200">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-slate-950" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path>
                        </svg>
                        Standard Ownership
                    </div>
                </c:when>
                <c:when test="${sessionScope.userRole == 'owner' and sessionScope.loggedUser.subscriptionStatus == 'Free'}">
                    <a href="subscribe.jsp" class="flex items-center gap-3 p-3 rounded-xl bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold transition-all shadow-lg shadow-orange-500/20 hover:shadow-orange-500/40 transform hover:-translate-y-0.5 group">
                        <div class="w-8 h-8 rounded-lg bg-white/20 text-white group-hover:bg-white group-hover:text-orange-600 flex items-center justify-center transition-all duration-200">
                            <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                            </svg>
                        </div>
                        <span class="tracking-wide">Upgrade to Premium</span>
                    </a>
                </c:when>
            </c:choose>
            
            <a href="profileController" class="flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">
                <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-slate-200 group-hover:text-slate-700 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg></div> My Profile Settings
            </a>
            
            <a href="properties" class="flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">
                <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-slate-200 group-hover:text-slate-700 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg></div> My Properties
            </a>
            
            <a href="rentalController?action=duePayments" class="flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">
                <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-slate-200 group-hover:text-slate-700 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg></div> Due Payments
            </a>
            
            <a href="reportController?action=viewTickets" class="flex items-center gap-3 p-3 rounded-xl hover:bg-slate-100 text-slate-700 hover:text-slate-900 font-bold transition-all group">
                <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-slate-200 group-hover:text-slate-700 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path></svg></div> My Support Tickets
            </a>
        </div>
        
        <div class="p-6 border-t border-slate-100 bg-slate-50">
            <form id="logoutFormDrawer" action="auth" method="POST" class="m-0">
                <input type="hidden" name="action" value="logout">
                <button type="submit" class="w-full flex items-center justify-center gap-2 bg-white border border-red-200 text-red-600 hover:bg-red-50 hover:border-red-300 font-bold py-3 rounded-xl shadow-sm transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>Secure Logout</button>
            </form>
        </div>
    </div>
    
    <script>
        function toggleProfileDrawer() {
            const drawer = document.getElementById('profileDrawer');
            const backdrop = document.getElementById('profileBackdrop');
            if (drawer.classList.contains('translate-x-full')) {
                backdrop.classList.remove('hidden');
                setTimeout(() => { backdrop.classList.remove('opacity-0'); }, 10);
                drawer.classList.remove('translate-x-full');
            } else {
                backdrop.classList.add('opacity-0');
                drawer.classList.add('translate-x-full');
                setTimeout(() => { backdrop.classList.add('hidden'); }, 300);
            }
        }
    </script>
</body>
</html>