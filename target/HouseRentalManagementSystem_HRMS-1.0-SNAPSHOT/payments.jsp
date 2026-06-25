<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Payment Gateway</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes blob { 0% { transform: translate(0px, 0px) scale(1); } 33% { transform: translate(30px, -50px) scale(1.1); } 66% { transform: translate(-20px, 20px) scale(0.9); } 100% { transform: translate(0px, 0px) scale(1); } }
        .animate-blob { animation: blob 7s infinite; }
        .animation-delay-2000 { animation-delay: 2s; }
        .loader { border: 4px solid #f3f4f6; border-top: 4px solid #f97316; border-radius: 50%; width: 40px; height: 40px; animation: spin 1s linear infinite; margin: 0 auto; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .modal-enter { opacity: 0; transform: scale(0.95); transition: all 0.3s ease-out; }
        .modal-enter-active { opacity: 1; transform: scale(1); }
        @media print {
            body * { visibility: hidden; }
            #receiptContent, #receiptContent * { visibility: visible; }
            #receiptContent { position: absolute; left: 0; top: 0; width: 100%; box-shadow: none; }
            .no-print { display: none !important; }
        }
    </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen relative overflow-x-hidden">

    <div class="absolute top-0 left-20 w-96 h-96 bg-orange-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob pointer-events-none z-0"></div>
    <div class="absolute top-40 right-20 w-96 h-96 bg-blue-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob animation-delay-2000 pointer-events-none z-0"></div>

    <nav class="bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-50 shadow-sm">
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
                <a href="paymentController" class="text-orange-500 border-b-2 border-orange-500 pb-1">Payments</a>
            </div>
            <div class="flex items-center gap-4">
                <button onclick="toggleProfileDrawer()" class="w-10 h-10 rounded-full bg-gradient-to-tr from-orange-400 to-orange-500 text-white font-black flex items-center justify-center shadow-md hover:shadow-lg hover:scale-105 transition-all outline-none focus:ring-4 focus:ring-orange-200">
                    <c:choose>
                        <c:when test="${sessionScope.userRole == 'admin'}">A</c:when>
                        <c:otherwise>${sessionScope.loggedUser.fullName.substring(0,1).toUpperCase()}</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-6 py-12 relative z-10">
        <c:if test="${not empty param.error}">
            <div class="bg-red-50 border border-red-200 rounded-2xl p-6 mb-8 flex items-center gap-4 shadow-sm">
                <div class="w-12 h-12 bg-red-100 text-red-600 rounded-full flex items-center justify-center shrink-0"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg></div>
                <div>
                    <h3 class="text-lg font-bold text-red-900">Transaction Failed</h3>
                    <p class="text-red-600 text-sm font-mono mt-1">${param.error}</p>
                </div>
            </div>
        </c:if>

        <c:if test="${param.success == 'true'}">
            <div class="bg-green-50 border border-green-200 rounded-2xl p-6 mb-8 flex items-center gap-4 shadow-sm">
                <div class="w-12 h-12 bg-green-100 text-green-600 rounded-full flex items-center justify-center shrink-0"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg></div>
                <div>
                    <h3 class="text-lg font-bold text-green-900">Payment Successful!</h3>
                    <p class="text-green-700 text-sm">Your rent has been securely processed and saved to your history.</p>
                </div>
            </div>
        </c:if>

        <div class="mb-8">
            <h2 class="text-3xl font-extrabold text-slate-900">Payment Gateway</h2>
            <p class="text-slate-500 mt-1">Sandbox Environment for System Prototypes.</p>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <div class="lg:col-span-1">
                <div class="bg-white rounded-3xl shadow-sm border border-slate-100 p-8">
                    <h3 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2"><svg class="w-5 h-5 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path></svg>Make a Payment</h3>
                    <c:choose>
                        <c:when test="${empty activeRentals}">
                            <div class="bg-slate-50 border border-slate-200 rounded-xl p-6 text-center"><p class="text-slate-500 text-sm font-bold">You don't have any active rentals to pay for yet.</p></div>
                        </c:when>
                        <c:otherwise>
                            <form id="paymentForm" action="paymentController" method="POST" class="space-y-5">
                                <input type="hidden" name="action" value="payRent">
                                <c:forEach items="${activeRentals}" var="rental">
                                    <input type="hidden" name="rentalId" value="${rental.rentalId}">
                                    <input type="hidden" name="amount" value="${rental.rentalRate}">
                                    <div class="bg-slate-50 p-4 rounded-xl border border-slate-200 mb-4">
                                        <p class="text-xs font-bold text-slate-400 uppercase mb-1">Paying Rent For</p>
                                        <p class="font-bold text-slate-800">${rental.propertyName}</p>
                                        <div class="mt-3 flex justify-between items-center border-t border-slate-200 pt-3"><span class="text-sm font-bold text-slate-500">Amount Due:</span><span class="text-lg font-black text-orange-600">RM ${rental.rentalRate}</span></div>
                                    </div>
                                </c:forEach>
                                <div>
                                    <label class="block text-xs font-bold text-slate-500 uppercase mb-2">Payment Method</label>
                                    <select name="paymentMethod" required class="w-full bg-slate-50 border border-slate-200 text-slate-800 p-3 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none">
                                        <option value="Sandbox FPX">Sandbox FPX (Bank Transfer)</option>
                                        <option value="Sandbox Credit Card">Sandbox Credit Card</option>
                                    </select>
                                </div>
                                <button type="button" onclick="simulatePayment()" class="w-full bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold py-4 rounded-xl shadow-lg transition-all mt-4 flex justify-center items-center gap-2"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>Secure Pay Now</button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="lg:col-span-2">
                <div class="bg-white rounded-3xl shadow-sm border border-slate-100 overflow-hidden">
                    <div class="p-6 border-b border-slate-100"><h3 class="text-lg font-bold text-slate-900">Payment History</h3></div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse min-w-max">
                            <thead>
                                <tr class="bg-slate-50 text-slate-500 text-xs uppercase tracking-wider border-b border-slate-100">
                                    <th class="p-5 font-bold">Trans ID</th>
                                    <th class="p-5 font-bold">Date</th>
                                    <th class="p-5 font-bold">Property</th>
                                    <th class="p-5 font-bold">Status</th>
                                    <th class="p-5 font-bold text-right">Amount</th>
                                    <th class="p-5 font-bold text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100">
                                <c:forEach items="${paymentHistory}" var="pay">
                                    <tr class="hover:bg-slate-50 transition-colors">
                                        <td class="p-5 font-black text-slate-800 text-sm">PAY-${pay.paymentId}</td>
                                        <td class="p-5 text-slate-500 text-sm">${pay.paymentDate}</td>
                                        <td class="p-5 text-slate-600 text-sm truncate max-w-[150px]">${pay.propertyName}</td>
                                        <td class="p-5"><span class="bg-green-100 text-green-700 font-bold text-xs px-3 py-1 rounded-full">${pay.paymentStatus}</span></td>
                                        <td class="p-5 text-right font-black text-slate-900">RM ${pay.amount}</td>
                                        <td class="p-5 text-center"><button type="button" onclick="openReceiptModal('PAY-${pay.paymentId}', '${pay.paymentDate}', '${pay.propertyName}', '${pay.amount}', '${pay.paymentMethod}')" class="text-orange-500 hover:text-orange-700 font-bold text-sm underline transition-colors">View Receipt</button></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty paymentHistory}"><tr><td colspan="6" class="p-8 text-center text-slate-500 font-bold">No payment history found.</td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <div id="processingModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center">
        <div class="absolute inset-0 bg-slate-900/80 backdrop-blur-md"></div>
        <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-10 w-full max-w-sm text-center modal-enter" id="processingContent">
            <div class="loader mb-6"></div>
            <h2 class="text-2xl font-black text-slate-900 tracking-tight mb-2">Processing Payment</h2>
            <p class="text-slate-500 text-sm">Please do not close or refresh this window.<br>Connecting to secure sandbox gateway...</p>
        </div>
    </div>

    <div id="receiptModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center p-4">
        <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm no-print" onclick="closeReceipt()"></div>
        <div class="relative bg-white rounded-2xl border border-slate-200 shadow-2xl p-8 w-full max-w-md modal-enter" id="receiptContent">
            <button onclick="closeReceipt()" class="absolute top-4 right-4 text-slate-400 hover:text-slate-700 no-print"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>
            <div class="text-center mb-6 border-b border-slate-100 pb-6">
                <div class="w-16 h-16 bg-green-100 text-green-500 rounded-full flex items-center justify-center mx-auto mb-3"><svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg></div>
                <h2 class="text-2xl font-black text-slate-900 tracking-tight">Payment Receipt</h2>
                <p class="text-slate-500 text-sm">Rent4Student Platform</p>
            </div>
            <div class="space-y-4 text-sm">
                <div class="flex justify-between"><span class="text-slate-500 font-bold uppercase text-xs">Transaction ID</span><span class="font-black text-slate-900" id="recTransId">--</span></div>
                <div class="flex justify-between"><span class="text-slate-500 font-bold uppercase text-xs">Date & Time</span><span class="font-bold text-slate-800" id="recDate">--</span></div>
                <div class="flex justify-between"><span class="text-slate-500 font-bold uppercase text-xs">Payment Method</span><span class="font-bold text-slate-800" id="recMethod">--</span></div>
                <div class="flex justify-between"><span class="text-slate-500 font-bold uppercase text-xs">Property</span><span class="font-bold text-slate-800 text-right max-w-[200px]" id="recProp">--</span></div>
                <div class="mt-6 pt-4 border-t border-slate-200 border-dashed flex justify-between items-center"><span class="text-slate-500 font-bold uppercase text-sm">Amount Paid</span><span class="font-black text-2xl text-slate-900" id="recAmount">--</span></div>
            </div>
            <div class="mt-8 pt-6 border-t border-slate-100 no-print">
                <button onclick="window.print()" class="w-full bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold py-3 rounded-xl transition-colors flex justify-center items-center gap-2"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>Print Receipt</button>
            </div>
        </div>
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

    <script>
        function simulatePayment() {
            document.getElementById('processingModal').classList.remove('hidden');
            setTimeout(() => { document.getElementById('processingContent').classList.add('modal-enter-active'); }, 10);
            setTimeout(() => { document.getElementById('paymentForm').submit(); }, 2000);
        }

        const rModal = document.getElementById('receiptModal');
        const rContent = document.getElementById('receiptContent');
        function openReceiptModal(transId, date, propName, amount, method) {
            document.getElementById('recTransId').innerText = transId;
            document.getElementById('recDate').innerText = date;
            document.getElementById('recProp').innerText = propName;
            document.getElementById('recAmount').innerText = "RM " + amount;
            document.getElementById('recMethod').innerText = method;
            rModal.classList.remove('hidden');
            setTimeout(() => { rContent.classList.add('modal-enter-active'); }, 10);
        }
        function closeReceipt() {
            rContent.classList.remove('modal-enter-active');
            setTimeout(() => { rModal.classList.add('hidden'); }, 300);
        }

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