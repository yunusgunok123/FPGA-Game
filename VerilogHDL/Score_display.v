module Score_display(
    input [16:0] score,    // 17-bit input to accommodate 5-digit decimal score (0-99999)
    output wire [3:0] digit4, // Tens of thousands place
    output wire [3:0] digit3, // Thousands place
    output wire [3:0] digit2, // Hundreds place
    output wire [3:0] digit1, // Tens place
    output wire [3:0] digit0  // Units place
);

    wire [16:0] sub_score1, sub_score2, sub_score3, sub_score4;

    // Tens of thousands
    assign digit4 = (score >= 90000) ? 9 :
                    (score >= 80000) ? 8 :
                    (score >= 70000) ? 7 :
                    (score >= 60000) ? 6 :
                    (score >= 50000) ? 5 :
                    (score >= 40000) ? 4 :
                    (score >= 30000) ? 3 :
                    (score >= 20000) ? 2 :
                    (score >= 10000) ? 1 : 0;

    // Subtract tens of thousands part
    assign sub_score1 = score - digit4 * 10000;

    // Thousands
    assign digit3 = (sub_score1 >= 9000) ? 9 :
                    (sub_score1 >= 8000) ? 8 :
                    (sub_score1 >= 7000) ? 7 :
                    (sub_score1 >= 6000) ? 6 :
                    (sub_score1 >= 5000) ? 5 :
                    (sub_score1 >= 4000) ? 4 :
                    (sub_score1 >= 3000) ? 3 :
                    (sub_score1 >= 2000) ? 2 :
                    (sub_score1 >= 1000) ? 1 : 0;

    // Subtract thousands part
    assign sub_score2 = sub_score1 - digit3 * 1000;

    // Hundreds
    assign digit2 = (sub_score2 >= 900) ? 9 :
                    (sub_score2 >= 800) ? 8 :
                    (sub_score2 >= 700) ? 7 :
                    (sub_score2 >= 600) ? 6 :
                    (sub_score2 >= 500) ? 5 :
                    (sub_score2 >= 400) ? 4 :
                    (sub_score2 >= 300) ? 3 :
                    (sub_score2 >= 200) ? 2 :
                    (sub_score2 >= 100) ? 1 : 0;

    // Subtract hundreds part
    assign sub_score3 = sub_score2 - digit2 * 100;

    // Tens
    assign digit1 = (sub_score3 >= 90) ? 9 :
                    (sub_score3 >= 80) ? 8 :
                    (sub_score3 >= 70) ? 7 :
                    (sub_score3 >= 60) ? 6 :
                    (sub_score3 >= 50) ? 5 :
                    (sub_score3 >= 40) ? 4 :
                    (sub_score3 >= 30) ? 3 :
                    (sub_score3 >= 20) ? 2 :
                    (sub_score3 >= 10) ? 1 : 0;

    // Subtract tens part
    assign sub_score4 = sub_score3 - digit1 * 10;

    // Units
    assign digit0 = sub_score4;

endmodule