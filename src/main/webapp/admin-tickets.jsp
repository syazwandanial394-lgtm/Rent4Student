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

        <c:if test="${param.success == 'resolved'}">
            <div class="bg-emerald-900/30 border border-emerald-500/50 rounded-xl p-4 mb-6 flex items-center gap-4">
                <p class="text-emerald-400 text-sm font-bold">Ticket reviewed and resolved successfully. Action logged.</p>
            </div>
        </c:if>

        <div class="admin-card rounded-xl border shadow-2xl">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-900/50 border-b border-slate-700 text-xs font-black text-slate-400 uppercase tracking-wider">
                            <th class="p-5">Ticket ID</th>
                            <th class="p-5">Date Submitted</th>
                            <th class="p-5">Sender</th>
                            <th class="p-5 w-1/3">Subject</th>
                            <th class="p-5 text-center">Status</th>
                            <th class="p-5 text-right">Action</th>
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
                                <td class="p-5 text-center">
                                    <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest border 
                                        ${ticket[4] == 'Pending' ? 'border-yellow-500/30 text-yellow-500 bg-yellow-500/10' : 
                                          ticket[4] == 'Resolved' ? 'border-emerald-500/30 text-emerald-500 bg-emerald-500/10' : 
                                          'border-red-500/30 text-red-500 bg-red-500/10'}">${ticket[4]}</span>
                                </td>
                                <td class="p-5 text-right">
                                    <c:choose>
                                        <c:when test="${ticket[4] == 'Pending'}">
                                            <button onclick="openModal('modal-${ticket[0]}')" class="bg-blue-600/20 hover:bg-blue-600 text-blue-400 hover:text-white border border-blue-500/50 font-bold py-1.5 px-4 rounded-lg transition-colors text-xs uppercase tracking-wider">Review</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button onclick="openModal('modal-${ticket[0]}')" class="text-slate-500 hover:text-slate-300 transition-colors text-xs font-bold underline uppercase tracking-wider">View Remarks</button>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <div id="modal-${ticket[0]}" class="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-[100] hidden items-center justify-center p-4 text-left transition-opacity">
                                <div class="bg-slate-900 rounded-3xl shadow-2xl max-w-lg w-full overflow-hidden border border-slate-700">
                                    <div class="bg-slate-800/80 p-6 border-b border-slate-700 flex justify-between items-center">
                                        <h3 class="text-xl font-black text-white">Ticket TK-${ticket[0]}</h3>
                                        <button type="button" onclick="closeModal('modal-${ticket[0]}')" class="text-slate-400 hover:text-white transition-colors"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>
                                    </div>
                                    <div class="p-6">
                                        
                                        <div class="mb-6 p-4 bg-[#0b1121] rounded-xl border border-slate-800">
                                            <p class="text-[10px] text-slate-500 uppercase font-bold mb-2 tracking-widest">Message from ${ticket[2]} (${ticket[3]})</p>
                                            <p class="text-slate-300 text-sm leading-relaxed">${ticket[6]}</p> </div>

                                        <c:choose>
                                            <c:when test="${ticket[4] == 'Pending'}">
                                                <form action="adminController" method="POST" class="m-0">
                                                    <input type="hidden" name="action" value="resolveTicket">
                                                    <input type="hidden" name="ticketId" value="${ticket[0]}">
                                                    
                                                    <label class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Update Status</label>
                                                    <select name="status" class="w-full bg-slate-800 border border-slate-700 text-slate-200 text-sm rounded-xl p-3.5 mb-5 outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
                                                        <option value="Resolved">Mark as Resolved (Unblock User / Fix Issue)</option>
                                                        <option value="Dismissed">Dismiss (Keep Blocked / Reject)</option>
                                                    </select>

                                                    <label class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Admin Remarks</label>
                                                    <textarea name="remarks" rows="3" required class="w-full bg-slate-800 border border-slate-700 text-white placeholder-slate-500 p-3.5 rounded-xl focus:ring-1 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all mb-6 text-sm resize-none" placeholder="Explain your decision or action taken..."></textarea>
                                                    
                                                    <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3.5 rounded-xl transition-colors shadow-lg shadow-blue-900/50 text-sm">Submit Resolution</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="p-4 bg-slate-800/50 rounded-xl border border-slate-700">
                                                    <p class="text-[10px] text-blue-400 uppercase font-bold mb-2 tracking-widest">Admin Remarks (${ticket[4]})</p>
                                                    <p class="text-slate-200 text-sm leading-relaxed">${ticket[7]}</p> </div>
                                            </c:otherwise>
                                        </c:choose>

                                    </div>
                                </div>
                            </div>

                        </c:forEach>
                        <c:if test="${empty ticketList}">
                            <tr><td colspan="6" class="p-10 text-center text-slate-500">No support tickets found in the database.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <script>
        function openModal(id) {
            document.getElementById(id).classList.remove('hidden');
            document.getElementById(id).classList.add('flex');
        }
        function closeModal(id) {
            document.getElementById(id).classList.add('hidden');
            document.getElementById(id).classList.remove('flex');
        }
    </script>
</body>
</html>