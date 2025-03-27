// module testbench;

//     logic clk, 
//     logic rst,
//     logic wire start,
//     logic wire done_money,
//     logic wire continue_buy,
//     logic wire cancel,
//     logic wire [1:0] item, // 00, 01, 10
//     logic wire deno_5, deno_10, deno_20,

//     logic end_trans,
//     logic [7:0] sum_money,
//     logic [7:0] price

//     //  Typedef: <type_name>
//     //  --- Prototype ---
//     //  typedef enum #() <type_name>
//     //  ---
//     typedef enum #() <type_name>;
    

//     task reset;

//     endtask

//     task IDLE(  input start         = 0, 
//                 input done_money    = 0, 
//                 input continue_buy  = 0, 
//                 input cancel        = 0,  
//                 input [1:0] item    = 0,
//                 input deno_5        = 0, 
//                 input deno_10       = 0, 
//                 input deno_20       = 0);
//     // Khai báo task print
//     task print(input [31:0] a);   // Tham số a là một giá trị kiểu 32-bit
//         $display("%d", a);         // In ra giá trị của a dưới dạng số thập phân
//     endtask

//     // Khai báo các tín hiệu cần thiết
//     initial begin
//         // Gọi task print với các giá trị khác nhau
//         print(0);   // Output: 0
//         print(10);  // Output: 10
//         print(255); // Output: 255
//     end

// endmodule

class intf;
    logic [31:0] sum;
    logic [31:0] product;
endclass

module test;

    // Định nghĩa struct để nhóm nhiều giá trị
    // Khai báo function trả về struct
    function automatic result_t compute_values(input [31:0] a = 1, input [31:0] b = 2, input [31:0] c = 3);
        result_t result;  // Biến kiểu struct để lưu kết quả
        result.sum = a + b + c;
        result.product = a * b * c;
        compute_values = result;  // Trả về struct
    endfunction

    // Khai báo các tín hiệu cần thiết
    reg [31:0] a, b, c;
    result_t result;

    initial begin
        // Gọi function với các giá trị mặc định và lưu kết quả vào struct
        result = compute_values(a, b, c);
        $display("Sum: %d, Product: %d", result.sum, result.product);  // Output: Sum: 6, Product: 6

        // Thay đổi các giá trị a, b, c và gọi lại function
        a = 4; b = 5; c = 6;
        result = compute_values(a, b, c);
        $display("Sum: %d, Product: %d", result.sum, result.product);  // Output: Sum: 15, Product: 120
    end

endmodule
