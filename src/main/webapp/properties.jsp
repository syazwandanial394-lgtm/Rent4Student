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
        
        input[type=number]::-webkit-inner-spin-button, 
        input[type=number]::-webkit-outer-spin-button { 
            -webkit-appearance: none; 
            margin: 0; 
        }
        input[type=number] {
            -moz-appearance: textfield;
        }
    </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen relative overflow-x-hidden overflow-y-scroll">

    <div class="absolute top-0 left-20 w-96 h-96 bg-orange-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob pointer-events-none z-0"></div>
    <div class="absolute top-40 right-20 w-96 h-96 bg-blue-300 rounded-full mix-blend-multiply filter blur-[120px] opacity-20 animate-blob animation-delay-2000 pointer-events-none z-0"></div>

    <nav class="bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-50 shadow-sm relative z-[60]">
        <div class="max-w-7xl mx-auto px-6 py-3 flex justify-between items-center">
            <div class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-orange-500" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72l5 2.73 5-2.73v3.72z"/></svg>
                <h1 class="text-2xl font-black text-slate-900 tracking-tight">Rent<span class="text-orange-500">4</span>Student</h1>
            </div>
            
            <div class="hidden md:flex gap-6 text-sm font-bold text-slate-600">
                <a href="dashboard" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Dashboard</a>
                <a href="properties" class="text-orange-500 border-b-2 border-orange-500 pb-1">Properties</a>
                <a href="applicationController" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Applications</a>
                <a href="rentalController" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Rentals</a>
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'student'}"><a href="paymentController" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Payments</a></c:when>
                    <c:when test="${sessionScope.userRole == 'owner'}"><a href="receipts.jsp" class="border-b-2 border-transparent hover:text-orange-500 transition-colors pb-1">Receipts</a></c:when>
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
        
        <c:if test="${param.success == 'added'}">
            <div class="bg-green-50 border border-green-200 rounded-2xl p-4 mb-6 flex items-center gap-4 shadow-sm">
                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                <p class="text-green-700 text-sm font-bold">Property successfully listed!</p>
            </div>
        </c:if>

        <c:if test="${hasActiveRental}">
            <div class="bg-blue-50 border border-blue-200 rounded-2xl p-6 mb-8 flex items-center gap-4 shadow-sm">
                <div class="w-12 h-12 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center shrink-0">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-slate-900">You have an active lease!</h3>
                    <p class="text-slate-600 text-sm">You cannot apply for new properties while you hold an active tenancy agreement. If you wish to move, request a termination in the Rentals tab.</p>
                </div>
            </div>
        </c:if>

        <div class="flex justify-between items-end mb-8">
            <div>
                <h2 class="text-3xl font-extrabold text-slate-900">Property Listings</h2>
                <p class="text-slate-500 mt-1">Browse and manage housing options.</p>
            </div>
            
            <c:if test="${sessionScope.userRole == 'owner'}">
                <button onclick="openAddPropModal()" class="bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-500 hover:to-blue-600 text-white font-bold py-3 px-6 rounded-xl shadow-lg transition-all flex items-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                    Add New Property
                </button>
            </c:if>
        </div>

        <c:if test="${sessionScope.userRole == 'student'}">
            <form action="properties" method="GET" class="bg-white p-4 rounded-2xl shadow-sm border border-slate-200 mb-8 flex flex-col md:flex-row gap-4 items-center">
                
                <div class="flex-1 w-full relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path></svg></div>
                    <input type="text" name="searchLocation" value="${param.searchLocation}" placeholder="City or location..." class="w-full pl-12 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all text-sm font-medium">
                </div>
                
                <div class="flex-1 w-full relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                    </div>
                    <select name="houseType" class="w-full pl-12 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all text-sm font-medium text-slate-600 appearance-none">
                        <option value="Any" ${param.houseType == 'Any' ? 'selected' : ''}>Any Property Type</option>
                        <option value="Apartment" ${param.houseType == 'Apartment' ? 'selected' : ''}>Apartment / Flat</option>
                        <option value="Terrace" ${param.houseType == 'Terrace' ? 'selected' : ''}>Terrace House</option>
                        <option value="Semi-D" ${param.houseType == 'Semi-D' ? 'selected' : ''}>Semi-D</option>
                        <option value="Bungalow" ${param.houseType == 'Bungalow' ? 'selected' : ''}>Bungalow</option>
                        <option value="Studio" ${param.houseType == 'Studio' ? 'selected' : ''}>Studio / Room</option>
                    </select>
                </div>

                <div class="flex-1 w-full relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400 font-bold text-sm">RM</div>
                    <input type="number" name="maxPrice" value="${param.maxPrice}" placeholder="Max Budget" min="100" max="15000" step="50" class="w-full pl-12 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-orange-500 outline-none transition-all text-sm font-medium">
                </div>
                
                <div class="w-full md:w-auto flex gap-2">
                    <button type="submit" class="flex-1 md:flex-none bg-slate-900 hover:bg-slate-800 text-white font-bold py-3 px-8 rounded-xl transition-all shadow-md">Search</button>
                    <c:if test="${isSearch}">
                        <a href="properties" class="flex items-center justify-center bg-red-50 hover:bg-red-100 text-red-600 font-bold py-3 px-4 rounded-xl transition-all border border-red-200"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></a>
                    </c:if>
                </div>
            </form>
        </c:if>

        <c:choose>
            <c:when test="${isSearch}">
                <h3 class="text-xl font-black text-slate-900 mb-6 border-b border-slate-200 pb-4">
                    Search Results <span class="text-slate-500 font-normal text-lg">(${propertyList.size()} found)</span>
                </h3>
            </c:when>
            <c:when test="${showingRecommendations}">
                <div class="mb-6 border-b border-slate-200 pb-4 flex justify-between items-end">
                    <h3 class="text-xl font-black text-slate-900 flex items-center gap-2">
                        <svg class="w-6 h-6 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"></path></svg>
                        Recommended in ${sessionScope.loggedUser.preferredLocation}
                    </h3>
                </div>
            </c:when>
            <c:otherwise>
                <h3 class="text-xl font-black text-slate-900 mb-6 border-b border-slate-200 pb-4">All Properties</h3>
            </c:otherwise>
        </c:choose>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <c:forEach items="${propertyList}" var="property">
                <div class="bg-white rounded-3xl overflow-hidden shadow-sm border ${showingRecommendations ? 'border-orange-200 shadow-md' : 'border-slate-100'} hover:shadow-xl hover:-translate-y-1 transition-all duration-300 relative">
                    
                    <c:if test="${showingRecommendations}">
                        <div class="absolute top-4 left-4 bg-orange-500 text-white text-[10px] font-black uppercase px-3 py-1 rounded-full z-10 shadow-sm flex items-center gap-1">
                            <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                            Match
                        </div>
                    </c:if>

                    <div class="h-40 bg-slate-200 relative">
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
                        
                        <span class="inline-block bg-slate-100 text-slate-600 text-xs font-bold px-2 py-1 rounded-md mb-2">${property.propertyType}</span>
                        <p class="text-slate-600 text-sm mb-4 line-clamp-2">${property.description}</p>

                        <p class="text-slate-500 text-sm mb-4 flex items-center gap-1 font-semibold">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                            ${property.city}, ${property.postcode}
                        </p>

                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'owner'}">
                                <button class="w-full bg-blue-50 text-blue-600 hover:bg-blue-100 font-bold py-3 rounded-xl transition-colors">Edit Listing</button>
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
                                        <button type="button" onclick="openModal('${property.propertyId}', '${property.propertyName}')" class="w-full ${showingRecommendations ? 'bg-orange-500 hover:bg-orange-600' : 'bg-slate-900 hover:bg-slate-800'} text-white font-bold py-3 rounded-xl transition-colors disabled:opacity-50" ${property.availabilityStatus == 'Available' ? '' : 'disabled'}>Apply Now</button>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty propertyList}">
                <div class="col-span-1 md:col-span-2 lg:col-span-3 bg-white border border-slate-200 rounded-3xl p-10 text-center shadow-sm">
                    <svg class="w-16 h-16 text-slate-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    <p class="text-slate-500 font-bold text-lg mb-2">No properties found matching your criteria.</p>
                    <c:if test="${showingRecommendations}">
                        <p class="text-slate-400 text-sm mb-4">We couldn't find any homes currently available in ${sessionScope.loggedUser.preferredLocation}.</p>
                    </c:if>
                </div>
            </c:if>
        </div>
    </main>

    <c:if test="${sessionScope.userRole == 'student' && !hasActiveRental}">
        <div id="applicationModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center p-4">
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
        <div id="addPropModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center p-4">
            <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeAddPropModal()"></div>
            <div class="relative bg-white rounded-3xl border border-slate-200 shadow-2xl p-8 w-full max-w-2xl modal-enter max-h-[90vh] overflow-y-auto" id="addPropContent">
                <div class="flex justify-between items-center border-b border-slate-100 pb-4 mb-6">
                    <h2 class="text-2xl font-black text-slate-900">List New Property</h2>
                    <button onclick="closeAddPropModal()" class="text-slate-400 hover:text-red-500"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>
                </div>
                
                <form action="properties" method="POST" enctype="multipart/form-data" class="space-y-4">
                    <input type="hidden" name="action" value="addProperty">
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-slate-500 uppercase mb-2">Property Name</label>
                            <input type="text" name="propertyName" required class="w-full bg-slate-50 border border-slate-200 p-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-slate-500 uppercase mb-2">Property Type</label>
                            <select name="propertyType" required class="w-full bg-slate-50 border border-slate-200 p-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none">
                                <option value="Apartment">Apartment / Flat</option>
                                <option value="Terrace">Terrace House</option>
                                <option value="Semi-D">Semi-D</option>
                                <option value="Bungalow">Bungalow</option>
                                <option value="Studio">Studio / Room</option>
                            </select>
                        </div>
                        
                        <div class="md:col-span-2">
                            <label class="block text-xs font-bold text-slate-500 uppercase mb-2">Property Image (Optional)</label>
                            <input type="file" name="propertyImage" accept="image/*" class="w-full bg-slate-50 border border-slate-200 p-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-bold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100 transition-all cursor-pointer">
                        </div>

                        <div class="md:col-span-2">
                            <label class="block text-xs font-bold text-slate-500 uppercase mb-2">Description</label>
                            <textarea name="description" rows="3" placeholder="e.g. 3 Bedrooms, fully furnished, near beach..." required class="w-full bg-slate-50 border border-slate-200 p-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"></textarea>
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-xs font-bold text-slate-500 uppercase mb-2">Full Address</label>
                            <input type="text" name="address" required class="w-full bg-slate-50 border border-slate-200 p-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-slate-500 uppercase mb-2">City</label>
                            <input type="text" name="city" required class="w-full bg-slate-50 border border-slate-200 p-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-slate-500 uppercase mb-2">Postcode</label>
                            <input type="text" name="postcode" required class="w-full bg-slate-50 border border-slate-200 p-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none">
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-xs font-bold text-slate-500 uppercase mb-2">Monthly Rent (RM)</label>
                            <input type="number" step="0.01" name="rentalRate" required class="w-full bg-slate-50 border border-slate-200 p-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none">
                        </div>
                    </div>
                    
                    <div class="pt-4 mt-2 border-t border-slate-100 flex justify-end gap-3">
                        <button type="button" onclick="closeAddPropModal()" class="px-6 py-3 font-bold text-slate-600 bg-slate-100 rounded-xl hover:bg-slate-200">Cancel</button>
                        <button type="submit" class="px-6 py-3 font-bold text-white bg-blue-600 rounded-xl hover:bg-blue-700 shadow-md">Publish Listing</button>
                    </div>
                </form>
            </div>
        </div>
        <script>
            function openAddPropModal() {
                document.getElementById('addPropModal').classList.remove('hidden');
                setTimeout(() => { document.getElementById('addPropContent').classList.add('modal-enter-active'); }, 10);
            }
            function closeAddPropModal() {
                document.getElementById('addPropContent').classList.remove('modal-enter-active');
                setTimeout(() => { document.getElementById('addPropModal').classList.add('hidden'); }, 300);
            }
        </script>
    </c:if>

    <div id="profileBackdrop" onclick="toggleProfileDrawer()" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-[100] hidden opacity-0 transition-opacity duration-300"></div>
    <div id="profileDrawer" class="fixed top-0 right-0 h-full w-80 bg-white shadow-2xl z-[101] transform translate-x-full transition-transform duration-300 ease-in-out flex flex-col border-l border-slate-100">
        <div class="p-6 bg-slate-50 border-b border-slate-100 flex justify-between items-start">
            <div class="flex items-center gap-4">
                <div class="w-14 h-14 rounded-full bg-orange-100 text-orange-600 font-black flex items-center justify-center text-2xl shadow-inner">
                    <c:choose><c:when test="${sessionScope.userRole == 'admin'}">A</c:when><c:otherwise>${sessionScope.loggedUser.fullName.substring(0,1).toUpperCase()}</c:otherwise></c:choose>
                </div>
                <div>
                    <p class="font-bold text-slate-900 leading-tight">
                        <c:choose><c:when test="${sessionScope.userRole == 'admin'}">${sessionScope.adminName}</c:when><c:otherwise>${sessionScope.loggedUser.fullName}</c:otherwise></c:choose>
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
            
            <c:if test="${sessionScope.userRole == 'owner'}">
                <a href="properties" class="flex items-center gap-3 p-3 rounded-xl hover:bg-orange-50 text-slate-700 hover:text-orange-600 font-bold transition-all group">
                    <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-500 group-hover:bg-orange-100 group-hover:text-orange-500 flex items-center justify-center transition-colors"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg></div>
                    My Property Info
                </a>
            </c:if>
        </div>
        <div class="p-6 border-t border-slate-100 bg-slate-50">
            <form action="auth" method="POST" class="m-0">
                <input type="hidden" name="action" value="logout">
                <button type="submit" class="w-full flex items-center justify-center gap-2 bg-white border border-red-200 text-red-600 hover:bg-red-50 hover:border-red-300 font-bold py-3 rounded-xl shadow-sm transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>Secure Logout</button>
            </form>
        </div>
    </div>
    <script>
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