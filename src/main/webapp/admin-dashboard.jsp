<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole or sessionScope.userRole != 'admin'}">
    <c:redirect url="login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>HRMS | System Administration</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { background-color: #0f172a; } /* Deep Slate 950 */
        .admin-card { background-color: #1e293b; border-color: #334155; } /* Slate 800 */
    </style>
</head>
<body class="font-sans text-slate-300 min-h-screen relative selection:bg-red-500 selection:text-white">

    <!-- TOP NAVIGATION BAR -->
    <nav class="bg-[#0b1121] border-b border-slate-800 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
            <div class="flex items-center gap-4">
                <h1 class="text-xl font-black tracking-[0.2em] text-red-500 uppercase">Rent4Student <span class="text-white">Root</span></h1>
                <span class="bg-red-600 text-white text-xs font-bold px-3 py-1 rounded-sm tracking-widest uppercase">Admin Mode</span>
            </div>
            <div class="flex items-center gap-6 text-sm">
                <span class="text-slate-400">Authorized: <span class="text-white font-bold">System Administrator</span></span>
                <form action="auth" method="POST" class="m-0">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="border border-red-600 text-red-500 hover:bg-red-600 hover:text-white font-bold py-1.5 px-5 rounded transition-colors uppercase tracking-wider text-xs">Terminate Session</button>
                </form>
            </div>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-6 py-10">
        
        <!-- 1. ADMINISTRATIVE VIEW (System Overview Metrics) -->
        <div class="mb-10">
            <h2 class="text-3xl font-black text-white mb-6 tracking-tight">System Overview</h2>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                <!-- Server Status -->
                <div class="admin-card rounded-xl p-6 border shadow-lg">
                    <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-2">Server Status</p>
                    <h3 class="text-2xl font-black text-emerald-400 mb-1">ONLINE</h3>
                    <p class="text-xs text-slate-500">Tomcat 10 / Jakarta EE 10</p>
                </div>
                
                <!-- Database -->
                <div class="admin-card rounded-xl p-6 border shadow-lg">
                    <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-2">Database Connection</p>
                    <h3 class="text-2xl font-black text-emerald-400 mb-1">ACTIVE</h3>
                    <p class="text-xs text-slate-500">MySQL: hrms_db</p>
                </div>
                
                <!-- Active Sessions -->
                <div class="admin-card rounded-xl p-6 border shadow-lg">
                    <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-2">Active Sessions</p>
                    <h3 class="text-2xl font-black text-blue-400 mb-1">1</h3>
                    <p class="text-xs text-slate-500">Current Admin Session</p>
                </div>

                <!-- Unresolved Tickets -->
                <div class="admin-card rounded-xl p-6 border shadow-lg border-b-4 border-b-yellow-500">
                    <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-2">Pending Tickets</p>
                    <h3 class="text-2xl font-black text-yellow-400 mb-1">Requires Action</h3>
                    <p class="text-xs text-slate-500">Awaiting Admin Response</p>
                </div>
            </div>
        </div>

        <hr class="border-slate-800 mb-10">

        <!-- CORE ADMINISTRATIVE TOOLS -->
        <div>
            <h2 class="text-2xl font-black text-white mb-6 tracking-tight flex items-center gap-3">
                <svg class="w-6 h-6 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"></path></svg>
                Management Modules
            </h2>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                
                <!-- 2. SUPPORT TICKETS MODULE -->
                <a href="adminController?action=viewTickets" class="admin-card rounded-xl border p-8 hover:border-yellow-500/50 hover:bg-slate-800 transition-all group relative overflow-hidden">
                    <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                        <svg class="w-24 h-24 text-yellow-500" fill="currentColor" viewBox="0 0 24 24"><path d="M15 4a8 8 0 018 8 8 8 0 01-8 8H5a2 2 0 01-2-2V6a2 2 0 012-2h10zm0 2H5v12h10a6 6 0 000-12zm-2 3a1 1 0 011 1v4a1 1 0 01-2 0V10a1 1 0 011-1z"></path></svg>
                    </div>
                    <div class="w-12 h-12 rounded-lg bg-yellow-500/10 text-yellow-500 flex items-center justify-center mb-6">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                    </div>
                    <h3 class="text-xl font-bold text-white mb-2 group-hover:text-yellow-400 transition-colors">Support Tickets</h3>
                    <p class="text-sm text-slate-400 leading-relaxed">Review, reply, and resolve help desk tickets submitted by Students and House Owners.</p>
                </a>

                <!-- 3. USER ENFORCEMENT MODULE (Block/Terminate) -->
                <a href="adminController?action=manageUsers" class="admin-card rounded-xl border p-8 hover:border-red-500/50 hover:bg-slate-800 transition-all group relative overflow-hidden">
                    <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                        <svg class="w-24 h-24 text-red-500" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11H7v-2h10v2z"></path></svg>
                    </div>
                    <div class="w-12 h-12 rounded-lg bg-red-500/10 text-red-500 flex items-center justify-center mb-6">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                    </div>
                    <h3 class="text-xl font-bold text-white mb-2 group-hover:text-red-400 transition-colors">Account Enforcement</h3>
                    <p class="text-sm text-slate-400 leading-relaxed">Suspend, block, or permanently terminate accounts for inappropriate behavior or violations.</p>
                </a>

                <!-- 4. ACTIVITY LOGS MODULE -->
                <a href="adminController?action=activityLogs" class="admin-card rounded-xl border p-8 hover:border-blue-500/50 hover:bg-slate-800 transition-all group relative overflow-hidden">
                    <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                        <svg class="w-24 h-24 text-blue-500" fill="currentColor" viewBox="0 0 24 24"><path d="M4 6h16v2H4zm0 5h16v2H4zm0 5h16v2H4z"></path></svg>
                    </div>
                    <div class="w-12 h-12 rounded-lg bg-blue-500/10 text-blue-500 flex items-center justify-center mb-6">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                    </div>
                    <h3 class="text-xl font-bold text-white mb-2 group-hover:text-blue-400 transition-colors">Activity Logs</h3>
                    <p class="text-sm text-slate-400 leading-relaxed">Monitor platform usage, view detailed transaction histories, and audit system events.</p>
                </a>

            </div>
        </div>
    </main>

</body>
</html>