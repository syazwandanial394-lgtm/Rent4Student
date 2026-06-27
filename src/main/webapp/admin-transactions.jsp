<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole or sessionScope.userRole != 'admin'}">
    <c:redirect url="login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>HRMS | Transaction Logs</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { background-color: #0f172a; }
        .admin-card { background-color: #1e293b; border-color: #334155; }
    </style>
</head>
<body class="font-sans text-slate-300 min-h-screen selection:bg-emerald-500 selection:text-white">

    <nav class="bg-[#0b1121] border-b border-slate-800 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
            <h1 class="text-xl font-black tracking-[0.2em] text-red-500 uppercase">Rent4Student <span class="text-white">Root</span></h1>
            <a href="admin-dashboard.jsp" class="text-slate-400 hover:text-white font-bold text-sm transition-colors">Return to Dashboard</a>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-6 py-10">
        <div class="flex justify-between items-end mb-8 border-b border-slate-800 pb-4">
            <div>
                <h2 class="text-3xl font-black text-white flex items-center gap-3">
                    <svg class="w-8 h-8 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    System Transaction Logs
                </h2>
                <p class="text-slate-500 mt-2">Audit trail of all financial movements and rent payments on the platform.</p>
            </div>
        </div>

        <div class="admin-card rounded-xl border overflow-hidden shadow-2xl">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-900/50 border-b border-slate-700 text-xs font-black text-slate-400 uppercase tracking-wider">
                            <th class="p-5">Transaction ID</th>
                            <th class="p-5">Date & Time</th>
                            <th class="p-5">Amount</th>
                            <th class="p-5 text-right">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-700/50 font-mono text-sm">
                        <c:forEach items="${transactionList}" var="txn">
                            <tr class="hover:bg-slate-800/50 transition-colors">
                                <td class="p-5 text-slate-500">TXN-${txn[0]}</td>
                                <td class="p-5 text-slate-400">${txn[1]}</td>
                                <td class="p-5 text-emerald-400 font-bold font-sans tracking-wide">RM ${txn[2]}</td>
                                <td class="p-5 text-right">
                                    <span class="px-3 py-1 rounded-full text-[10px] font-sans font-bold uppercase tracking-widest border border-slate-600 bg-slate-800 text-slate-300">${txn[3]}</span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty transactionList}">
                            <tr><td colspan="4" class="p-10 text-center text-slate-500 font-sans">No financial transactions found in the database.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</body>
</html>