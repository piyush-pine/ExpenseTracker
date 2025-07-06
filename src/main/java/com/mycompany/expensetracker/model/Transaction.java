package com.mycompany.expensetracker.model;

import java.util.Date;

public class Transaction {
    private int id;
    private String name;
    private double amount;
    private String category;
    private Date date;
    private int userId;
    private String username;
    private String notes;
    private String tags;
    private String type; // Added type field

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }

    public String getType() { return type; }           // Getter for type
    public void setType(String type) { this.type = type; } // Setter for type
}
