<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:if test="${empty sessionScope.loggedUser}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student - Official Receipts</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen overflow-y-scroll">
    
<<<<<<< HEAD
    <nav class="bg-blue-600 p-4 text-white flex justify-between items-center shadow-md">
        <div class="flex gap-6 items-center">
            <h1 class="font-bold text-xl">RentEase</h1>
            <a href="dashboard" class="text-blue-200 hover:text-white">Dashboard</a>
            <a href="properties" class="text-blue-200 hover:text-white">Properties</a>
            <a href="applicationController" class="text-blue-200 hover:text-white">Applications</a>
            <a href="rentalController" class="text-blue-200 hover:text-white">Rentals</a>
            <c:if test="${sessionScope.userRole == 'student'}">
                <a href="paymentController" class="text-blue-200 hover:text-white">Payments</a>
            </c:if>
            <a href="receipt" class="text-white font-bold border-b-2 border-white">Receipts</a>
=======
    <nav class="bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-50 shadow-sm relative z-[60]">
        <div class="max-w-7xl mx-auto px-6 py-3 flex justify-between items-center">
            <div class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-orange-500" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72l5 2.73 5-2.73v3.72z"/></svg>
                <h1 class="text-2xl font-black text-slate-900 tracking-tight">Rent<span class="text-orange-500">4</span>Student</h1>
            </div>
            
            <div class="hidden md:flex gap-6 text-sm font-bold text-slate-600">
                <a href="dashboard" class="hover:text-orange-500 transition-colors pb-1">Dashboard</a>
                <a href="properties" class="hover:text-orange-500 transition-colors pb-1">Properties</a>
                <a href="applicationController" class="hover:text-orange-500 transition-colors pb-1">Applications</a>
                <a href="rentalController" class="hover:text-orange-500 transition-colors pb-1">Rentals</a>
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'student'}"><a href="paymentController" class="hover:text-orange-500 transition-colors pb-1">Payments</a></c:when>
                    <c:when test="${sessionScope.userRole == 'owner'}"><a href="receipt" class="text-orange-500 border-b-2 border-orange-500 pb-1">Receipts</a></c:when>
                </c:choose>
            </div>
            
            <div class="flex items-center gap-4">
                <button onclick="toggleProfileDrawer()" class="w-10 h-10 rounded-full bg-gradient-to-tr from-orange-400 to-orange-500 text-white font-black flex items-center justify-center shadow-md hover:shadow-lg hover:scale-105 transition-all outline-none focus:ring-4 focus:ring-orange-200">
                    <c:choose>
                        <c:when test="${sessionScope.userRole == 'admin'}">A</c:when>
                        <c:otherwise>${sessionScope.loggedUser.fullName.substring(0,1).toUpperCase()}</c:otherwise>
                    </c:choose>
                </button>
            </div>
>>>>>>> de851cef4aedcaa524a4224b59e664b07a27926f
        </div>
    </nav>

    <main class="p-8 max-w-7xl mx-auto mt-6">
        
        <div class="flex justify-between items-end mb-8">
<<<<<<< HEAD
            <div>
                <h2 class="text-3xl font-extrabold text-gray-800">Official Receipts Ledger</h2>
                <p class="text-gray-500 mt-1">Track your property revenue and platform service fees.</p>
            </div>
            <button onclick="window.print()" class="bg-gray-800 hover:bg-gray-900 text-white px-4 py-2 rounded font-bold shadow flex gap-2 items-center transition-colors">
=======
            <h2 class="text-3xl font-extrabold text-gray-800">Official Receipts</h2>
            <button onclick="window.print()" class="bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-500 hover:to-blue-600 text-white font-bold py-3 px-6 rounded-xl shadow-lg transition-all flex items-center gap-2">
>>>>>>> de851cef4aedcaa524a4224b59e664b07a27926f
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" /></svg>
                Print Ledger
            </button>
        </div>

        <div class="bg-white shadow border rounded-lg overflow-x-auto">
            <table class="w-full text-left border-collapse min-w-max">
                <thead>
                    <tr class="bg-gray-800 text-white text-xs uppercase tracking-wider">
                        <th class="p-4 font-bold">Receipt ID</th>
                        <th class="p-4 font-bold">Issue Date</th>
                        <th class="p-4 font-bold">Method</th>
                        <th class="p-4 font-bold text-right bg-gray-900">Owner Revenue</th>
                        <th class="p-4 font-bold text-right text-gray-400">+ Platform Fee (3%)</th>
                        <th class="p-4 font-bold text-right bg-gray-700">Total Paid by Student</th>
                        <th class="p-4 font-bold text-center">Status</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <c:forEach var="receipt" items="${receiptList}">
                        <tr class="hover:bg-gray-50 transition-colors">
                            <td class="p-4 font-mono font-bold text-blue-600 text-sm">RCPT-${receipt.receiptId}</td>
                            <td class="p-4 text-sm text-gray-600">${receipt.issueDate}</td>
                            <td class="p-4 text-sm text-gray-600">${receipt.paymentMethod}</td>
                            
                            <td class="p-4 text-right font-black text-green-600 bg-green-50/30">
                                RM <fmt:formatNumber value="${receipt.amountPaid}" pattern="0.00"/>
                            </td>
                            <td class="p-4 text-right font-medium text-gray-400 text-sm">
                                RM <fmt:formatNumber value="${receipt.amountPaid * 0.03}" pattern="0.00"/>
                            </td>
                            <td class="p-4 text-right font-black text-gray-900 bg-gray-50">
                                RM <fmt:formatNumber value="${receipt.amountPaid * 1.03}" pattern="0.00"/>
                            </td>
                            
                            <td class="p-4 text-center">
                                <span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-xs font-bold uppercase">
                                    ${receipt.receiptStatus}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty receiptList}">
                        <tr><td colspan="7" class="p-8 text-center text-gray-500 font-bold">No receipts have been generated yet.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        <div id="profileBackdrop" onclick="toggleProfileDrawer()" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-[100] hidden opacity-0 transition-opacity duration-300"></div>
        <div id="profileDrawer" class="fixed top-0 right-0 h-full w-80 bg-white shadow-2xl z-[101] transform translate-x-full transition-transform duration-300 ease-in-out flex flex-col border-l border-slate-100">
            <div class="p-6 bg-slate-50 border-b border-slate-100 flex justify-between items-start">
                <div class="flex items-center gap-4">
                    <div class="w-14 h-14 rounded-full bg-orange-100 text-orange-600 font-black flex items-center justify-center text-2xl shadow-inner">
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'admin'}">A</c:when>
                            <c:otherwise>${sessionScope.loggedUser.fullName.substring(0,1).toUpperCase()}</c:otherwise>
                        </c:choose>
                    </div>
                    <div>
                        <p class="font-bold text-slate-900 leading-tight">
                            <c:choose>
                                <c:when test="${sessionScope.userRole == 'admin'}">${sessionScope.adminName}</c:when>
                                <c:otherwise>${sessionScope.loggedUser.fullName}</c:otherwise>
                            </c:choose>
                        </p>
                        <p class="text-xs font-bold text-orange-500 uppercase tracking-widest mt-1">${sessionScope.userRole}</p>
                    </div>
                </div>
                <button onclick="toggleProfileDrawer()" class="text-slate-400 hover:text-red-500 transition-colors bg-white rounded-full p-1 shadow-sm"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>
            </div>
            <div class="p-4 flex-1 flex flex-col gap-2">
                <c:choose >
                    <c:when test="${sessionScope.userRole == 'owner' and sessionScope.loggedUser.subscriptionStatus == 'Premium'}">
                        <div class="inline-flex items-center gap-3 px-6 py-3.5 bg-gradient-to-r from-yellow-500 via-amber-400 to-yellow-600 text-slate-950 font-black rounded-2xl uppercase tracking-wider text-xs shadow-xl shadow-amber-500/20 border border-yellow-300/40 transform hover:scale-[1.02] transition-all duration-200">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-slate-950" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path>
                            </svg>
                            Premium Owner Unlocked
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
                <a href="profileController" class="flex items-center gap-3 p-3 rounded-xl hover:bg-orange-50 text-slate-700 hover:text-orange-600 font-bold transition-all group">
                    <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-orange-100 group-hover:text-orange-500 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg></div>
                    My Profile Settings
                </a>
                <a href="dashboard" class="flex items-center gap-3 p-3 rounded-xl hover:bg-orange-50 text-slate-700 hover:text-orange-600 font-bold transition-all group">
                    <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-orange-100 group-hover:text-orange-500 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg></div>
                    Dashboard Home
                </a>
            </div>
            <div class="p-6 border-t border-slate-100 bg-slate-50">
                <form action="auth" method="POST" class="m-0">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="w-full flex items-center justify-center gap-2 bg-white border border-red-200 text-red-600 hover:bg-red-50 hover:border-red-300 font-bold py-3 rounded-xl shadow-sm transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>Secure Logout</button>
                </form>
            </div>
        </div>
    </main>
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