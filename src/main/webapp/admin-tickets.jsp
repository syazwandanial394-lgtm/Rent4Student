<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole or sessionScope.userRole != 'admin'}">
    <c:redirect url="login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>HRMS | Support Tickets</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { background-color: #0f172a; }
        .admin-card { background-color: #1e293b; border-color: #334155; }
    </style>
</head>
<body class="font-sans text-slate-300 min-h-screen selection:bg-yellow-500 selection:text-slate-900">

    <nav class="bg-[#0b1121] border-b border-slate-800 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
            <div class="flex items-center gap-4">
                <h1 class="text-xl font-black tracking-[0.2em] text-red-500 uppercase">Rent4Student <span class="text-white">Root</span></h1>
            </div>
            <div class="flex items-center gap-4">
                <a href="admin-dashboard.jsp" class="text-slate-400 hover:text-white font-bold text-sm transition-colors">Return to Dashboard</a>
            </div>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-6 py-10">
        <div class="flex justify-between items-end mb-8 border-b border-slate-800 pb-4">
            <div>
                <h2 class="text-3xl font-black text-white flex items-center gap-3">
                    <svg class="w-8 h-8 text-yellow-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 4a8 8 0 018 8 8 8 0 01-8 8H5a2 2 0 01-2-2V6a2 2 0 012-2h10zm0 2H5v12h10a6 6 0 000-12zm-2 3a1 1 0 011 1v4a1 1 0 01-2 0V10a1 1 0 011-1z"></path></svg>
                    Support Tickets
                </h2>
                <p class="text-slate-500 mt-2">Global view of all system issues reported by users.</p>
            </div>
        </div>

        <div class="admin-card rounded-xl border overflow-hidden shadow-2xl">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-900/50 border-b border-slate-700 text-xs font-black text-slate-400 uppercase tracking-wider">
                            <th class="p-5">Ticket ID</th>
                            <th class="p-5">Date Submitted</th>
                            <th class="p-5">Sender</th>
                            <th class="p-5 w-1/2">Subject</th>
                            <th class="p-5 text-right">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-700/50">
                        <c:forEach items="${ticketList}" var="ticket">
                            <tr class="hover:bg-slate-800/50 transition-colors">
                                <td class="p-5 font-mono text-slate-400">TK-${ticket[0]}</td>
                                <td class="p-5 text-slate-400 text-sm">${ticket[5]}</td>
                                <td class="p-5">
                                    <p class="font-bold text-white">${ticket[2]}</p>
                                    <p class="text-xs text-slate-500 uppercase tracking-wider mt-1">${ticket[3]}</p>
                                </td>
                                <td class="p-5 text-white font-medium">${ticket[1]}</td>
                                <td class="p-5 text-right">
                                    <span class="px-3 py-1 rounded-full text-xs font-bold uppercase tracking-widest border ${ticket[4] == 'Pending' ? 'border-yellow-500/30 text-yellow-500 bg-yellow-500/10' : 'border-emerald-500/30 text-emerald-500 bg-emerald-500/10'}">${ticket[4]}</span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty ticketList}">
                            <tr><td colspan="5" class="p-10 text-center text-slate-500">No support tickets found in the database.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</body>
</html>