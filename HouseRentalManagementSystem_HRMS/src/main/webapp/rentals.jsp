<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Active Rentals</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes blob { 0% { transform: translate(0px, 0px) scale(1); } 33% { transform: translate(30px, -50px) scale(1.1); } 66% { transform: translate(-20px, 20px) scale(0.9); } 100% { transform: translate(0px, 0px) scale(1); } }
        .animate-blob { animation: blob 7s infinite; }
        .modal-enter { opacity: 0; transform: scale(0.95); transition: all 0.3s ease-out; }
        .modal-enter-active { opacity: 1; transform: scale(1); }
    </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen relative overflow-x-hidden">

    <div class="absolute top-40 right-20 w-96 h-96 bg-blue-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob pointer-events-none z-0"></div>

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
                <a href="rentalController" class="text-orange-500 border-b-2 border-orange-500 pb-1">Rentals</a>
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'student'}"><a href="paymentController" class="hover:text-orange-500 transition-colors pb-1">Payments</a></c:when>
                    <c:when test="${sessionScope.userRole == 'owner'}"><a href="receipts.jsp" class="hover:text-orange-500 transition-colors pb-1">Receipts</a></c:when>
                </c:choose>
            </div>
            
            <div class="flex items-center gap-4">
                <form action="auth" method="POST" class="m-0">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="bg-white hover:bg-red-50 text-red-600 border border-slate-200 font-bold py-2 px-4 rounded-xl transition-all text-sm shadow-sm">Logout</button>
                </form>
            </div>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-6 py-12 relative z-10">
        <div class="mb-8">
            <h2 class="text-3xl font-extrabold text-slate-900">Active Rentals</h2>
            <p class="text-slate-500 mt-1">Manage ongoing tenancy agreements.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <c:forEach items="${rentalList}" var="rental">
                <div class="bg-white rounded-3xl p-8 shadow-sm border border-slate-100 relative overflow-hidden">
                    <div class="absolute top-0 right-0 bg-blue-500 text-white text-xs font-black px-4 py-1 rounded-bl-xl">ACTIVE</div>
                    <h3 class="text-2xl font-bold text-slate-900 mb-4">${rental.propertyName}</h3>
                    <div class="space-y-3 mb-6">
                        <div class="flex justify-between text-sm"><span class="text-slate-500">Tenant:</span><span class="font-bold text-slate-800">${rental.studentName}</span></div>
                        <div class="flex justify-between text-sm"><span class="text-slate-500">Start Date:</span><span class="font-bold text-slate-800">${rental.startDate}</span></div>
                        <div class="flex justify-between text-sm"><span class="text-slate-500">Monthly Rent:</span><span class="font-black text-orange-600">RM ${rental.rentalRate}</span></div>
                    </div>
                    <div class="border-t border-slate-100 pt-6">
                        <button type="button" onclick="openAgreementModal('${rental.propertyName}', '${rental.studentName}', '${rental.startDate}', '${rental.rentalRate}')" class="w-full bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold py-3 rounded-xl transition-colors">View Agreement Details</button>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty rentalList}"><div class="col-span-2 bg-white rounded-2xl p-10 text-center border border-slate-100 shadow-sm"><p class="text-slate-500 font-bold text-lg">You have no active rental agreements at this time.</p></div></c:if>
        </div>
    </main>

    <div id="agreementModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center p-4">
        <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeAgreement()"></div>
        <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-8 w-full max-w-2xl modal-enter max-h-[90vh] overflow-y-auto" id="agreementContent">
            <div class="flex justify-between items-center border-b border-slate-100 pb-4 mb-6">
                <h2 class="text-2xl font-black text-slate-900 flex items-center gap-2"><svg class="w-6 h-6 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>Digital Tenancy Agreement</h2>
                <button onclick="closeAgreement()" class="text-slate-400 hover:text-red-500 transition-colors"><svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>
            </div>
            <div class="space-y-6 text-sm text-slate-600">
                <p>This document serves as the official digital record of tenancy between the listed parties through the Rent4Student platform.</p>
                <div class="bg-slate-50 rounded-xl p-5 border border-slate-200">
                    <div class="grid grid-cols-2 gap-y-4 gap-x-8">
                        <div><span class="block text-xs font-bold text-slate-400 uppercase">Property</span> <span class="font-bold text-slate-900 text-base" id="modalPropName">--</span></div>
                        <div><span class="block text-xs font-bold text-slate-400 uppercase">Tenant</span> <span class="font-bold text-slate-900 text-base" id="modalTenantName">--</span></div>
                        <div><span class="block text-xs font-bold text-slate-400 uppercase">Commencement Date</span> <span class="font-bold text-slate-900 text-base" id="modalStartDate">--</span></div>
                        <div><span class="block text-xs font-bold text-slate-400 uppercase">Monthly Rent</span> <span class="font-black text-orange-600 text-base" id="modalRent">--</span></div>
                    </div>
                </div>
                <div>
                    <h4 class="font-bold text-slate-900 mb-2">Standard Terms & Conditions</h4>
                    <ul class="list-disc pl-5 space-y-1 text-slate-500">
                        <li>Rent is due on the 1st of every month via the Rent4Student Payment Portal.</li>
                        <li>The tenant agrees to maintain the property in clean and proper condition.</li>
                        <li>Subletting is strictly prohibited without written owner consent.</li>
                        <li>Termination of this agreement requires a 30-day digital notice.</li>
                    </ul>
                </div>
            </div>
            <div class="mt-8 text-center pt-6 border-t border-slate-100">
                <p class="text-xs text-slate-400 uppercase tracking-widest font-bold">Electronically Verified by Rent4Student</p>
            </div>
        </div>
    </div>
    <script>
        const agModal = document.getElementById('agreementModal');
        const agContent = document.getElementById('agreementContent');
        function openAgreementModal(propName, tenantName, startDate, rent) {
            document.getElementById('modalPropName').innerText = propName;
            document.getElementById('modalTenantName').innerText = tenantName;
            document.getElementById('modalStartDate').innerText = startDate;
            document.getElementById('modalRent').innerText = "RM " + rent;
            agModal.classList.remove('hidden');
            setTimeout(() => { agContent.classList.add('modal-enter-active'); }, 10);
        }
        function closeAgreement() {
            agContent.classList.remove('modal-enter-active');
            setTimeout(() => { agModal.classList.add('hidden'); }, 300);
        }
    </script>
</body>
</html>