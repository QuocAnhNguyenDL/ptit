module test;

    // Khai báo task print
    task print(input [31:0] a);   // Tham số a là một giá trị kiểu 32-bit
        $display("%d", a);         // In ra giá trị của a dưới dạng số thập phân
    endtask

    // Khai báo các tín hiệu cần thiết
    initial begin
        // Gọi task print với các giá trị khác nhau
        print(0);   // Output: 0
        print(10);  // Output: 10
        print(255); // Output: 255
    end

endmodule
