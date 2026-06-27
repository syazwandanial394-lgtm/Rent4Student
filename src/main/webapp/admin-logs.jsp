<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole or sessionScope.userRole != 'admin'}">
    <c:redirect url="login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>HRMS | Activity Logs</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { background-color: #0f172a; }
        .admin-card { background-color: #1e293b; border-color: #334155; }
    </style>
</head>
<body class="font-sans text-slate-300 min-h-screen selection:bg-blue-500 selection:text-white">

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
                    <svg class="w-8 h-8 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                    System Activity Logs
                </h2>
                <p class="text-slate-500 mt-2">Immutable audit trail of administrative actions.</p>
            </div>
        </div>

        <div class="admin-card rounded-xl border overflow-hidden shadow-2xl">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-900/50 border-b border-slate-700 text-xs font-black text-slate-400 uppercase tracking-wider">
                            <th class="p-5">Log ID</th>
                            <th class="p-5">Timestamp</th>
                            <th class="p-5">Administrator</th>
                            <th class="p-5 w-1/2">Action Taken</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-700/50 font-mono text-sm">
                        <c:forEach items="${logList}" var="log">
                            <tr class="hover:bg-slate-800/50 transition-colors">
                                <td class="p-5 text-slate-500">#${log[0]}</td>
                                <td class="p-5 text-blue-400">${log[3]}</td>
                                <td class="p-5 text-white font-sans font-bold">${log[1]}</td>
                                <td class="p-5 text-slate-300 bg-slate-900/20">${log[2]}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty logList}">
                            <tr><td colspan="4" class="p-10 text-center text-slate-500 font-sans">No administrative actions have been logged yet.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</body>
</html>