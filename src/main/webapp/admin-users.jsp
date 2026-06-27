<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole or sessionScope.userRole != 'admin'}">
    <c:redirect url="login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>HRMS | Account Enforcement</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { background-color: #0f172a; }
        .admin-card { background-color: #1e293b; border-color: #334155; }
    </style>
</head>
<body class="font-sans text-slate-300 min-h-screen selection:bg-red-500 selection:text-white">

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
                    <svg class="w-8 h-8 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                    Account Enforcement
                </h2>
                <p class="text-slate-500 mt-2">Manage access privileges for all registered platforms users.</p>
            </div>
        </div>

        <c:if test="${param.success == 'updated'}">
            <div class="bg-emerald-900/30 border border-emerald-500/50 rounded-xl p-4 mb-6 flex items-center gap-4">
                <p class="text-emerald-400 text-sm font-bold">User account status updated successfully. Action logged.</p>
            </div>
        </c:if>

        <div class="admin-card rounded-xl border overflow-hidden shadow-2xl">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-900/50 border-b border-slate-700 text-xs font-black text-slate-400 uppercase tracking-wider">
                            <th class="p-5">User ID</th>
                            <th class="p-5">Username</th>
                            <th class="p-5">Role</th>
                            <th class="p-5">Status</th>
                            <th class="p-5 text-right">Enforcement Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-700/50">
                        <c:forEach items="${userList}" var="user">
                            <tr class="hover:bg-slate-800/50 transition-colors">
                                <td class="p-5 font-mono text-slate-400">UID-${user[0]}</td>
                                <td class="p-5 font-bold text-white">${user[1]}</td>
                                <td class="p-5">
                                    <span class="px-3 py-1 rounded-sm text-xs font-bold uppercase tracking-widest ${user[2] == 'Student' ? 'bg-orange-500/10 text-orange-400' : 'bg-blue-500/10 text-blue-400'}">${user[2]}</span>
                                </td>
                                <td class="p-5">
                                    <c:choose>
                                        <c:when test="${user[3] == 'Active'}"><span class="text-emerald-400 font-bold text-sm flex items-center gap-2"><div class="w-2 h-2 rounded-full bg-emerald-400"></div> Active</span></c:when>
                                        <c:when test="${user[3] == 'Blocked'}"><span class="text-yellow-400 font-bold text-sm flex items-center gap-2"><div class="w-2 h-2 rounded-full bg-yellow-400"></div> Blocked</span></c:when>
                                        <c:otherwise><span class="text-red-500 font-bold text-sm flex items-center gap-2"><div class="w-2 h-2 rounded-full bg-red-500"></div> Terminated</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="p-5 text-right">
                                    <form action="adminController" method="POST" class="m-0 flex items-center justify-end gap-2">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="userId" value="${user[0]}">
                                        <input type="hidden" name="targetRole" value="${user[2]}">
                                        <select name="status" class="bg-slate-900 border border-slate-600 text-slate-300 text-sm rounded-lg focus:ring-red-500 focus:border-red-500 block p-2 outline-none">
                                            <option value="Active" ${user[3] == 'Active' ? 'selected' : ''}>Active</option>
                                            <option value="Blocked" ${user[3] == 'Blocked' ? 'selected' : ''}>Blocked</option>
                                            <option value="Terminated" ${user[3] == 'Terminated' ? 'selected' : ''}>Terminated</option>
                                        </select>
                                        <button type="submit" class="bg-red-600/20 hover:bg-red-600 text-red-500 hover:text-white border border-red-500/50 font-bold py-2 px-4 rounded-lg transition-colors text-sm">Apply</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</body>
</html>