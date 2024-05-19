package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class GraphHome {

    public Map<String, Integer> getCompanyCounts() {
        Map<String, Integer> companyCounts = new HashMap<>();
        String query = "SELECT company, COUNT(*) AS count FROM quotationHistory GROUP BY company";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query);
                ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                String company = resultSet.getString("company");
                int count = resultSet.getInt("count");
                companyCounts.put(company, count);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return companyCounts;
    }
}
