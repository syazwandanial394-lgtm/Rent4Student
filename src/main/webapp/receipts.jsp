<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:if test="${empty sessionScope.loggedUser}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>HRMS - Official Receipts</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen overflow-y-scroll">
    
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
        </div>
        <form action="auth" method="POST" class="m-0">
            <input type="hidden" name="action" value="logout">
            <button type="submit" class="bg-red-500 hover:bg-red-600 px-3 py-1 rounded text-sm font-bold">Logout</button>
        </form>
    </nav>

    <main class="p-8 max-w-7xl mx-auto mt-6">
        
        <div class="flex justify-between items-end mb-8">
            <div>
                <h2 class="text-3xl font-extrabold text-gray-800">Official Receipts Ledger</h2>
                <p class="text-gray-500 mt-1">Track your property revenue and platform service fees.</p>
            </div>
            <button onclick="window.print()" class="bg-gray-800 hover:bg-gray-900 text-white px-4 py-2 rounded font-bold shadow flex gap-2 items-center transition-colors">
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
    </main>
</body>
</html>