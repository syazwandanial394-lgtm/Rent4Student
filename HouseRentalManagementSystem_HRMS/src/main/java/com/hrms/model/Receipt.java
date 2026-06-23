package com.hrms.model;

public class Receipt {
    private int receiptId;
    private String issueDate;
    private double amountPaid;
    private String receiptStatus;
    private String paymentMethod;
    private int paymentId;

    public Receipt() {}

    public int getReceiptId() { return receiptId; }
    public void setReceiptId(int receiptId) { this.receiptId = receiptId; }

    public String getIssueDate() { return issueDate; }
    public void setIssueDate(String issueDate) { this.issueDate = issueDate; }

    public double getAmountPaid() { return amountPaid; }
    public void setAmountPaid(double amountPaid) { this.amountPaid = amountPaid; }

    public String getReceiptStatus() { return receiptStatus; }
    public void setReceiptStatus(String receiptStatus) { this.receiptStatus = receiptStatus; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }
}