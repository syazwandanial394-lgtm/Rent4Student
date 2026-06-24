<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${empty sessionScope.loggedUser}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Receipts</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen relative overflow-x-hidden">
    
    <nav class="bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-50 shadow-sm">
        <div class="max-w-7xl mx-auto px-6 py-3 flex justify-between items-center">
            
            <div class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-orange-500" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72l5 2.73 5-2.73v3.72z"/></svg>
                <h1 class="text-2xl font-black text-slate-900 tracking-tight">Rent<span class="text-orange-500">4</span>Student</h1>
            </div>

            <div class="hidden md:flex gap-6 text-sm font-bold text-slate-600">
                <a href="dashboard.jsp" class="hover:text-orange-500 transition-colors pb-1">Dashboard</a>
                <a href="properties" class="hover:text-orange-500 transition-colors pb-1">Properties</a>
                <a href="applicationController" class="hover:text-orange-500 transition-colors pb-1">Applications</a>
                <a href="rentalController" class="hover:text-orange-500 transition-colors pb-1">Rentals</a>
                
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'student'}"><a href="paymentController" class="hover:text-orange-500 transition-colors pb-1">Payments</a></c:when>
                    <c:when test="${sessionScope.userRole == 'owner'}"><a href="receipts.jsp" class="hover:text-orange-500 transition-colors pb-1">Receipts</a></c:when>
                </c:choose>
            </div>

            <div class="flex items-center gap-4">
                <div class="text-right hidden sm:block">
                    <p class="text-sm font-bold text-slate-800 leading-tight">
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'admin'}">${sessionScope.adminName}</c:when>
                            <c:otherwise>${sessionScope.loggedUser.fullName}</c:otherwise>
                        </c:choose>
                    </p>
                    <p class="text-xs text-slate-500 capitalize">${sessionScope.userRole}</p>
                </div>
                <form action="auth" method="POST" class="m-0">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="bg-white hover:bg-red-50 text-red-600 border border-slate-200 font-bold py-2 px-4 rounded-xl transition-all text-sm shadow-sm">Logout</button>
                </form>
            </div>
        </div>
    </nav>

    <main class="p-8 max-w-5xl mx-auto mt-6">
        
        <div class="flex justify-between items-end mb-8">
            <h2 class="text-3xl font-extrabold text-gray-800">Official Receipts</h2>
            <button onclick="window.print()" class="bg-gray-800 hover:bg-gray-900 text-white px-4 py-2 rounded font-bold shadow flex gap-2 items-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" /></svg>
                Print Ledger
            </button>
        </div>

        <div class="bg-white shadow border rounded-lg overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-gray-800 text-white text-sm uppercase">
                        <th class="p-4">Receipt ID</th>
                        <th class="p-4">Issue Date</th>
                        <th class="p-4">Payment Ref #</th>
                        <th class="p-4">Method</th>
                        <th class="p-4 text-right">Amount Paid</th>
                        <th class="p-4 text-center">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="receipt" items="${receiptList}">
                        <tr class="border-b hover:bg-gray-50">
                            <td class="p-4 font-mono font-bold text-blue-600">RCPT-${receipt.receiptId}</td>
                            <td class="p-4">${receipt.issueDate}</td>
                            <td class="p-4 text-gray-500">PAY-${receipt.paymentId}</td>
                            <td class="p-4">${receipt.paymentMethod}</td>
                            <td class="p-4 text-right font-bold text-gray-800">RM ${receipt.amountPaid}</td>
                            <td class="p-4 text-center">
                                <span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-xs font-bold uppercase">
                                    ${receipt.receiptStatus}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty receiptList}">
                        <tr><td colspan="6" class="p-6 text-center text-gray-500">No receipts have been generated yet.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>