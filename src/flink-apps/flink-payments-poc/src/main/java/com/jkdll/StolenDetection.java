package com.jkdll;

import com.amazonaws.util.json.JSONException;
import com.amazonaws.util.json.JSONObject;
import org.apache.flink.api.common.functions.MapFunction;

import javax.management.remote.rmi._RMIConnection_Stub;
import java.io.IOException;

public class StolenDetection implements MapFunction<String, String> {
    @Override
    public String map(String s)  {
        String [] values = s.split("\\|");
        String event_type = values[0];
        String timestamp = values[1];
        String message = values[2];
        if (event_type.equals("PAYMENT_EVENT")) {
            try {
                JSONObject obj = new JSONObject(message);
                String json_event = obj.getString("event");
                String json_event_dt = obj.getString("event_timestamp");
                String json_amount = obj.getString("amount");
                String json_cardnumber = obj.getString("card_number");
                int json_stolen = obj.getInt("stolen");
                if (json_stolen == 1) {

                    String jsonString = new JSONObject()
                            .put("event", "PAYMENT_ALERT_SUMMARY")
                            .put("event_timestamp", timestamp)
                            .put("card_number",json_cardnumber)
                            .put("amount",json_amount)
                            .put("stolen",json_stolen).toString();

                    String result = "PAYMENT_ALERT|"+values[1]+"|"+jsonString + "\n";
                    return result;
                } else {
                    return null;
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return null;

    }
}
