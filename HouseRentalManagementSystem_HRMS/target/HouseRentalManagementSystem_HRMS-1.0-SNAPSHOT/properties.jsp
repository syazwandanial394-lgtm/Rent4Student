<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.userRole}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Rent4Student | Properties</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes blob { 0% { transform: translate(0px, 0px) scale(1); } 33% { transform: translate(30px, -50px) scale(1.1); } 66% { transform: translate(-20px, 20px) scale(0.9); } 100% { transform: translate(0px, 0px) scale(1); } }
        .animate-blob { animation: blob 7s infinite; }
        .animation-delay-2000 { animation-delay: 2s; }
        .modal-enter { opacity: 0; transform: scale(0.95); transition: all 0.3s ease-out; }
        .modal-enter-active { opacity: 1; transform: scale(1); }
    </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen relative overflow-x-hidden">

    <div class="absolute top-0 left-20 w-96 h-96 bg-orange-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob pointer-events-none z-0"></div>
    <div class="absolute top-40 right-20 w-96 h-96 bg-blue-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob animation-delay-2000 pointer-events-none z-0"></div>

    <nav class="bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-50 shadow-sm">
        <div class="max-w-7xl mx-auto px-6 py-3 flex justify-between items-center">
            <div class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-orange-500" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72l5 2.73 5-2.73v3.72z"/></svg>
                <h1 class="text-2xl font-black text-slate-900 tracking-tight">Rent<span class="text-orange-500">4</span>Student</h1>
            </div>
            
            <div class="hidden md:flex gap-6 text-sm font-bold text-slate-600">
                <a href="dashboard.jsp" class="hover:text-orange-500 transition-colors pb-1">Dashboard</a>
                <a href="properties" class="text-orange-500 border-b-2 border-orange-500 pb-1">Properties</a>
                <a href="applicationController" class="hover:text-orange-500 transition-colors pb-1">Applications</a>
                <a href="rentalController" class="hover:text-orange-500 transition-colors pb-1">Rentals</a>
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
        
        <c:if test="${hasActiveRental}">
            <div class="bg-blue-50 border border-blue-200 rounded-2xl p-6 mb-8 flex items-center gap-4">
                <div class="w-12 h-12 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center shrink-0">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-slate-900">You have an active lease!</h3>
                    <p class="text-slate-600 text-sm">You cannot apply for new properties while you hold an active tenancy agreement. Manage your current house in the Rentals tab.</p>
                </div>
            </div>
        </c:if>

        <div class="flex justify-between items-center mb-8">
            <div>
                <h2 class="text-3xl font-extrabold text-slate-900">Property Listings</h2>
                <p class="text-slate-500 mt-1">Browse and manage housing options.</p>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <c:forEach items="${propertyList}" var="property">
                <div class="bg-white rounded-3xl overflow-hidden shadow-sm border border-slate-100 hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
                    <div class="h-48 bg-slate-200 relative">
                        <img src="https://images.unsplash.com/photo-1564013799919-ab600027ffc6?auto=format&fit=crop&q=80&w=800" class="w-full h-full object-cover" alt="House">
                        <div class="absolute top-4 right-4 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full text-xs font-black uppercase shadow-sm ${property.availabilityStatus == 'Available' ? 'text-green-600' : 'text-red-600'}">
                            ${property.availabilityStatus}
                        </div>
                    </div>
                    <div class="p-6">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="text-xl font-bold text-slate-900 leading-tight truncate pr-2">${property.propertyName}</h3>
                            <span class="text-orange-600 font-black text-lg w-24 text-right shrink-0">RM ${property.rentalRate}</span>
                        </div>
                        <p class="text-slate-500 text-sm mb-4 flex items-center gap-1 font-semibold">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                            ${property.city}, ${property.postcode}
                        </p>

                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'owner'}">
                                <button type="button" 
                                        onclick="openEditModal('${property.propertyId}', '${property.propertyName}', '${property.propertyType}', '${property.address}', '${property.description}', '${property.rentalRate}', '${property.availabilityStatus}', '${property.city}', '${property.postcode}')" 
                                        class="w-full bg-orange-50 text-orange-600 hover:bg-orange-100 font-bold py-3 rounded-xl transition-colors">
                                    Edit Listing
                                </button>
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'student'}">
                                <c:choose>
                                    <c:when test="${hasActiveRental}">
                                        <button type="button" disabled class="w-full bg-slate-100 text-slate-400 font-bold py-3 rounded-xl cursor-not-allowed">Currently Rented</button>
                                    </c:when>
                                    <c:when test="${pendingProps.contains(property.propertyId)}">
                                        <button type="button" disabled class="w-full bg-yellow-50 text-yellow-600 border border-yellow-200 font-bold py-3 rounded-xl cursor-not-allowed">Application Pending</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" onclick="openModal('${property.propertyId}', '${property.propertyName}')" class="w-full bg-slate-900 hover:bg-orange-500 text-white font-bold py-3 rounded-xl transition-colors disabled:opacity-50" ${property.availabilityStatus == 'Available' ? '' : 'disabled'}>Apply Now</button>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>

    <c:if test="${sessionScope.userRole == 'student' && !hasActiveRental}">
        <div id="applicationModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center">
            <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeModal()"></div>
            <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-8 w-full max-w-lg modal-enter" id="modalContent">
                <button onclick="closeModal()" class="absolute top-4 right-4 text-slate-400 hover:text-slate-700"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>

                <div class="text-center mb-6">
                    <h2 class="text-2xl font-black text-slate-900 tracking-tight">Confirm Application</h2>
                    <p class="text-slate-500 mt-1 text-sm">You are applying for: <br><strong id="modalPropertyName" class="text-orange-600"></strong></p>
                </div>

                <form action="applicationController" method="POST" class="flex gap-3 mt-6">
                    <input type="hidden" name="action" value="confirmApply">
                    <input type="hidden" name="propertyId" id="modalPropertyId" value="">
                    <button type="button" onclick="closeModal()" class="w-1/3 bg-white border border-slate-300 hover:bg-slate-50 text-slate-700 font-bold py-3 rounded-xl transition-all shadow-sm">Cancel</button>
                    <button type="submit" class="w-2/3 bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold py-3 rounded-xl shadow-lg transition-all">Submit Application</button>
                </form>
            </div>
        </div>    
        <script>
            function openModal(id, name) {
                document.getElementById('modalPropertyId').value = id;
                document.getElementById('modalPropertyName').innerText = name;
                document.getElementById('applicationModal').classList.remove('hidden');
                setTimeout(() => { document.getElementById('modalContent').classList.add('modal-enter-active'); }, 10);
            }
            function closeModal() {
                document.getElementById('modalContent').classList.remove('modal-enter-active');
                setTimeout(() => { document.getElementById('applicationModal').classList.add('hidden'); }, 300);
            }
        </script>
    </c:if>
    <c:if test="${sessionScope.userRole == 'owner'}">
        <div id="editModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center">
            <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm overflow-y-auto" onclick="closeEditModal()"></div>
            <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-8 w-full max-w-2xl modal-enter my-8 z-10 max-h-[90vh] overflow-y-auto" id="editModalContent">
                <button onclick="closeEditModal()" class="absolute top-4 right-4 text-slate-400 hover:text-slate-700">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>

                <div class="text-center mb-6">
                    <h2 class="text-2xl font-black text-slate-900 tracking-tight">Edit Property</h2>
                    <p class="text-slate-500 mt-1 text-sm">Update your listing details below.</p>
                </div>

                <form action="properties" method="POST" class="space-y-4">
                    <input type="hidden" name="action" value="updateProperty">
                    <input type="hidden" name="propertyId" id="editPropertyId" value="">

                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-1">Property Name</label>
                            <input type="text" name="propertyName" id="editPropertyName" required class="w-full px-4 py-2 border border-slate-300 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-1">Property Type</label>
                            <input type="text" name="propertyType" id="editPropertyType" required placeholder="e.g. Apartment, Terrace" class="w-full px-4 py-2 border border-slate-300 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-1">Address</label>
                        <textarea name="address" id="editAddress" rows="2" required class="w-full px-4 py-2 border border-slate-300 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all"></textarea>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-1">Description</label>
                        <textarea name="description" id="editDescription" rows="3" required class="w-full px-4 py-2 border border-slate-300 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all"></textarea>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-1">Rental Rate (RM)</label>
                            <input type="number" step="0.01" name="rentalRate" id="editRentalRate" required class="w-full px-4 py-2 border border-slate-300 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-1">Status</label>
                            <select name="availabilityStatus" id="editStatus" class="w-full px-4 py-2 border border-slate-300 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all bg-white">
                                <option value="Available">Available</option>
                                <option value="Rented">Rented</option>
                                <option value="Maintenance">Maintenance</option>
                            </select>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-1">City</label>
                            <input type="text" name="city" id="editCity" required class="w-full px-4 py-2 border border-slate-300 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-1">Postcode</label>
                            <input type="text" name="postcode" id="editPostcode" required class="w-full px-4 py-2 border border-slate-300 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all">
                        </div>
                    </div>

                    <div class="flex gap-3 mt-6 pt-4 border-t border-slate-100">
                        <button type="button" onclick="closeEditModal()" class="w-1/3 bg-white border border-slate-300 hover:bg-slate-50 text-slate-700 font-bold py-3 rounded-xl transition-all shadow-sm">Cancel</button>
                        <button type="submit" class="w-2/3 bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-400 hover:to-orange-500 text-white font-bold py-3 rounded-xl shadow-lg transition-all">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openEditModal(id, name, type, address, description, rate, status, city, postcode) {
                document.getElementById('editPropertyId').value = id;
                document.getElementById('editPropertyName').value = name;
                document.getElementById('editPropertyType').value = type;
                document.getElementById('editAddress').value = address;
                document.getElementById('editDescription').value = description;
                document.getElementById('editRentalRate').value = rate;
                document.getElementById('editStatus').value = status;
                document.getElementById('editCity').value = city;
                document.getElementById('editPostcode').value = postcode;

                document.getElementById('editModal').classList.remove('hidden');
                setTimeout(() => { document.getElementById('editModalContent').classList.add('modal-enter-active'); }, 10);
            }

            function closeEditModal() {
                document.getElementById('editModalContent').classList.remove('modal-enter-active');
                setTimeout(() => { document.getElementById('editModal').classList.add('hidden'); }, 300);
            }
        </script>
    </c:if>
</body>
</html>