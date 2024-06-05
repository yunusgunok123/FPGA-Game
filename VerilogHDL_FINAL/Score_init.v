module Score_init(
    input [16:0] score,    // 17-bit input to accommodate 5-digit decimal score (0-99999)
    output wire [3:0] digits [4:0] // Tens of thousands place
);

    wire [16:0] sub_score1, sub_score2, sub_score3, sub_score4;

    // Tens of thousands
    assign digits[4] = (score >= 17'd90000) ? 4'd9 :
                    (score >= 17'd80000) ? 4'd8 :
                    (score >= 17'd70000) ? 4'd7 :
                    (score >= 17'd60000) ? 4'd6 :
                    (score >= 17'd50000) ? 4'd5 :
                    (score >= 17'd40000) ? 4'd4 :
                    (score >= 17'd30000) ? 4'd3 :
                    (score >= 17'd20000) ? 4'd2 :
                    (score >= 17'd10000) ? 4'd1 : 4'd0;

    // Subtract tens of thousands part
    assign sub_score1 = score - digits[4] * 17'd10000;

    // Thousands
    assign digits[3] = (sub_score1 >= 17'd9000) ? 4'd9 :
                    (sub_score1 >= 17'd8000) ? 4'd8 :
                    (sub_score1 >= 17'd7000) ? 4'd7 :
                    (sub_score1 >= 17'd6000) ? 4'd6 :
                    (sub_score1 >= 17'd5000) ? 4'd5 :
                    (sub_score1 >= 17'd4000) ? 4'd4 :
                    (sub_score1 >= 17'd3000) ? 4'd3 :
                    (sub_score1 >= 17'd2000) ? 4'd2 :
                    (sub_score1 >= 17'd1000) ? 4'd1 : 4'd0;

    // Subtract thousands part
    assign sub_score2 = sub_score1 - digits[3] * 17'd1000;

    // Hundreds
    assign digits[2] = (sub_score2 >= 17'd900) ? 4'd9 :
                    (sub_score2 >= 17'd800) ? 4'd8 :
                    (sub_score2 >= 17'd700) ? 4'd7 :
                    (sub_score2 >= 17'd600) ? 4'd6 :
                    (sub_score2 >= 17'd500) ? 4'd5 :
                    (sub_score2 >= 17'd400) ? 4'd4 :
                    (sub_score2 >= 17'd300) ? 4'd3 :
                    (sub_score2 >= 17'd200) ? 4'd2 :
                    (sub_score2 >= 17'd100) ? 4'd1 : 4'd0;

    // Subtract hundreds part
    assign sub_score3 = sub_score2 - digits[2] * 17'd100;

    // Tens
    assign digits[1] = (sub_score3 >= 17'd90) ? 9 :
                    (sub_score3 >= 17'd80) ? 8 :
                    (sub_score3 >= 17'd70) ? 7 :
                    (sub_score3 >= 17'd60) ? 6 :
                    (sub_score3 >= 17'd50) ? 5 :
                    (sub_score3 >= 17'd40) ? 4 :
                    (sub_score3 >= 17'd30) ? 3 :
                    (sub_score3 >= 17'd20) ? 2 :
                    (sub_score3 >= 17'd10) ? 1 : 0;

    // Subtract tens part
    assign sub_score4 = sub_score3 - digits[1] * 17'd10;

    // Units
    assign digits[0] = sub_score4;

endmodule