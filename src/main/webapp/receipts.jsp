<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${empty sessionScope.loggedUser}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>HRMS - Official Receipts</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
    
    <nav class="bg-blue-600 p-4 text-white flex justify-between items-center shadow-md">
        <div class="flex gap-6 items-center">
            <h1 class="font-bold text-xl">RentEase</h1>
            <a href="dashboard.jsp" class="text-blue-200 hover:text-white">Dashboard</a>
            <a href="property" class="text-blue-200 hover:text-white">Properties</a>
            <a href="application" class="text-blue-200 hover:text-white">Applications</a>
            <a href="rental" class="text-blue-200 hover:text-white">Rentals</a>
            <c:if test="${sessionScope.userRole == 'student'}">
                <a href="payment" class="text-blue-200 hover:text-white">Payments</a>
            </c:if>
            <a href="receipt" class="text-white font-bold border-b-2 border-white">Receipts</a>
        </div>
        <form action="auth" method="POST" class="m-0">
            <input type="hidden" name="action" value="logout">
            <button type="submit" class="bg-red-500 hover:bg-red-600 px-3 py-1 rounded text-sm font-bold">Logout</button>
        </form>
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