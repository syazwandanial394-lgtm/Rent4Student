<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Applications</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes blob { 0% { transform: translate(0px, 0px) scale(1); } 33% { transform: translate(30px, -50px) scale(1.1); } 66% { transform: translate(-20px, 20px) scale(0.9); } 100% { transform: translate(0px, 0px) scale(1); } }
        .animate-blob { animation: blob 7s infinite; }
        .modal-enter { opacity: 0; transform: scale(0.95); transition: all 0.3s ease-out; }
        .modal-enter-active { opacity: 1; transform: scale(1); }
    </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen relative overflow-x-hidden">

    <div class="absolute top-0 left-20 w-96 h-96 bg-orange-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob pointer-events-none z-0"></div>

    <nav class="bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-50 shadow-sm">
        <div class="max-w-7xl mx-auto px-6 py-3 flex justify-between items-center">
            <div class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-orange-500" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72l5 2.73 5-2.73v3.72z"/></svg>
                <h1 class="text-2xl font-black text-slate-900 tracking-tight">Rent<span class="text-orange-500">4</span>Student</h1>
            </div>
            
            <div class="hidden md:flex gap-6 text-sm font-bold text-slate-600">
                <a href="dashboard" class="hover:text-orange-500 transition-colors pb-1">Dashboard</a>
                <a href="properties" class="hover:text-orange-500 transition-colors pb-1">Properties</a>
                <a href="applicationController" class="text-orange-500 border-b-2 border-orange-500 pb-1">Applications</a>
                <a href="rentalController" class="hover:text-orange-500 transition-colors pb-1">Rentals</a>
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'student'}"><a href="paymentController" class="hover:text-orange-500 transition-colors pb-1">Payments</a></c:when>
                    <c:when test="${sessionScope.userRole == 'owner'}"><a href="receipts.jsp" class="hover:text-orange-500 transition-colors pb-1">Receipts</a></c:when>
                </c:choose>
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
                <div class="w-12 h-12 bg-red-100 text-red-600 rounded-full flex items-center justify-center shrink-0">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-red-900">Database Transaction Failed</h3>
                    <p class="text-red-600 text-sm font-mono mt-1">${param.error}</p>
                </div>
            </div>
        </c:if>

        <div class="mb-8">
            <h2 class="text-3xl font-extrabold text-slate-900">Application Status</h2>
            <p class="text-slate-500 mt-1">Track the progress of housing applications.</p>
        </div>

        <div class="bg-white rounded-3xl shadow-sm border border-slate-100 overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-slate-50 text-slate-500 text-xs uppercase tracking-wider border-b border-slate-100">
                        <th class="p-6 font-bold">Property</th>
                        <th class="p-6 font-bold">Applicant</th>
                        <th class="p-6 font-bold">Date Applied</th>
                        <th class="p-6 font-bold">Status</th>
                        <th class="p-6 font-bold text-right">Action</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    <c:forEach items="${applicationList}" var="app">
                        <tr class="hover:bg-slate-50 transition-colors">
                            <td class="p-6 font-bold text-slate-800">${app.propertyName}</td>
                            <td class="p-6 text-slate-600"><c:choose><c:when test="${sessionScope.userRole == 'owner'}">${app.studentName}</c:when><c:otherwise>${sessionScope.loggedUser.fullName}</c:otherwise></c:choose></td>
                            <td class="p-6 text-slate-500 text-sm">${app.applicationDate}</td>
                            <td class="p-6">
                                <c:choose>
                                    <c:when test="${app.status == 'Pending'}"><span class="bg-yellow-100 text-yellow-700 font-bold text-xs px-3 py-1 rounded-full">Pending</span></c:when>
                                    <c:when test="${app.status == 'Approved'}"><span class="bg-green-100 text-green-700 font-bold text-xs px-3 py-1 rounded-full">Approved</span></c:when>
                                    <c:when test="${app.status == 'Rejected' || app.status == 'Cancelled'}"><span class="bg-red-100 text-red-700 font-bold text-xs px-3 py-1 rounded-full">${app.status}</span></c:when>
                                    <c:otherwise><span class="bg-slate-100 text-slate-700 font-bold text-xs px-3 py-1 rounded-full">${app.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="p-6 text-right">
                                <c:if test="${app.status == 'Pending'}">
                                    <c:choose>
                                        <c:when test="${sessionScope.userRole == 'owner'}">
                                            <button type="button" onclick="openStatusModal('${app.applicationId}', '${app.propertyName}', 'Approved')" class="bg-green-100 hover:bg-green-200 text-green-700 font-bold py-2 px-4 rounded-lg text-sm mr-2 transition-colors">Approve</button>
                                            <button type="button" onclick="openStatusModal('${app.applicationId}', '${app.propertyName}', 'Rejected')" class="bg-red-100 hover:bg-red-200 text-red-700 font-bold py-2 px-4 rounded-lg text-sm transition-colors">Reject</button>
                                        </c:when>
                                        <c:when test="${sessionScope.userRole == 'student'}">
                                            <button type="button" onclick="openStatusModal('${app.applicationId}', '${app.propertyName}', 'Cancelled')" class="bg-red-50 hover:bg-red-100 text-red-600 font-bold py-2 px-4 rounded-lg text-sm transition-colors">Cancel</button>
                                        </c:when>
                                    </c:choose>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty applicationList}"><tr><td colspan="5" class="p-6 text-center text-slate-500 font-bold">No applications found.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </main>

    <div id="statusModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center">
        <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeStatusModal()"></div>
        <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-8 w-full max-w-sm modal-enter" id="statusModalContent">
            <div class="text-center mb-6">
                <div id="modalIconContainer" class="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4"></div>
                <h2 id="modalActionTitle" class="text-2xl font-black text-slate-900 tracking-tight">Action</h2>
                <p class="text-slate-500 mt-2 text-sm leading-relaxed">Are you sure you want to perform this action for <br><strong id="modalPropName" class="text-slate-800"></strong>? <br>This cannot be undone.</p>
            </div>
            <form action="applicationController" method="POST" class="flex gap-3">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="applicationId" id="modalAppId" value="">
                <input type="hidden" name="status" id="modalStatus" value="">
                <button type="button" onclick="closeStatusModal()" class="w-1/3 bg-white border border-slate-300 hover:bg-slate-50 text-slate-700 font-bold py-3 rounded-xl transition-all shadow-sm">Back</button>
                <button type="submit" id="modalSubmitBtn" class="w-2/3 text-white font-bold py-3 rounded-xl shadow-lg transition-all">Confirm</button>
            </form>
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
        const sModal = document.getElementById('statusModal');
        const sModalContent = document.getElementById('statusModalContent');
        function openStatusModal(appId, propName, newStatus) {
            document.getElementById('modalAppId').value = appId;
            document.getElementById('modalStatus').value = newStatus;
            document.getElementById('modalPropName').innerText = propName;

            const title = document.getElementById('modalActionTitle');
            const submitBtn = document.getElementById('modalSubmitBtn');
            const iconContainer = document.getElementById('modalIconContainer');

            if (newStatus === 'Approved') {
                title.innerText = 'Approve Application';
                submitBtn.className = 'w-2/3 bg-gradient-to-r from-green-500 to-green-600 hover:from-green-400 hover:to-green-500 text-white font-bold py-3 rounded-xl shadow-lg transition-all';
                submitBtn.innerText = 'Yes, Approve';
                iconContainer.className = 'w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4';
                iconContainer.innerHTML = '<svg class="w-8 h-8 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>';
            } 
            else if (newStatus === 'Rejected') {
                title.innerText = 'Reject Application';
                submitBtn.className = 'w-2/3 bg-gradient-to-r from-red-500 to-red-600 hover:from-red-400 hover:to-red-500 text-white font-bold py-3 rounded-xl shadow-lg transition-all';
                submitBtn.innerText = 'Yes, Reject';
                iconContainer.className = 'w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4';
                iconContainer.innerHTML = '<svg class="w-8 h-8 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>';
            }
            else if (newStatus === 'Cancelled') {
                title.innerText = 'Cancel Application';
                submitBtn.className = 'w-2/3 bg-gradient-to-r from-red-500 to-red-600 hover:from-red-400 hover:to-red-500 text-white font-bold py-3 rounded-xl shadow-lg transition-all';
                submitBtn.innerText = 'Yes, Cancel';
                iconContainer.className = 'w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4';
                iconContainer.innerHTML = '<svg class="w-8 h-8 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>';
            }
            sModal.classList.remove('hidden');
            setTimeout(() => { sModalContent.classList.add('modal-enter-active'); }, 10);
        }
        function closeStatusModal() {
            sModalContent.classList.remove('modal-enter-active');
            setTimeout(() => { sModal.classList.add('hidden'); }, 300);
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