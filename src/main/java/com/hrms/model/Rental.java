package com.hrms.model;

public class Rental {
    private int rentalId;
    private int propertyId;
    private int studentId;
    private int hoId;
    private String propertyName;
    private String studentName;
    private String startDate;
    private double rentalRate;
    
    // NEW FIELDS FOR TERMINATION
    private String status;
    private String terminationReason;

    public int getRentalId() { return rentalId; }
    public void setRentalId(int rentalId) { this.rentalId = rentalId; }

    public int getPropertyId() { return propertyId; }
    public void setPropertyId(int propertyId) { this.propertyId = propertyId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    
    public int getHoId() { return hoId; }
    public void setHoId(int hoId) { this.hoId = hoId; }

    public String getPropertyName() { return propertyName; }
    public void setPropertyName(String propertyName) { this.propertyName = propertyName; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }

    public double getRentalRate() { return rentalRate; }
    public void setRentalRate(double rentalRate) { this.rentalRate = rentalRate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getTerminationReason() { return terminationReason; }
    public void setTerminationReason(String terminationReason) { this.terminationReason = terminationReason; }
}