module top_tb;

    localparam FIVE = 3'b001,
               TEN = 3'b010,
               TWENTY = 3'b100,
               IDLE = 3'b000,
               SELECT = 3'b001,
               RECEIVE_MONEY = 3'b010,
               COMPARE = 3'b011,
               PROCESS = 3'b100,
               RETURN_CHANGE = 3'b101,
               MAX_MONEY = 8'd40;

     logic        clk;
     logic        reset_n;
     logic        start;
     logic        done_money;
     logic        continue_buy;
     logic        cancel;
     logic [1:0]  item_in;      
     logic [2:0]  money;  
//     logic        deno_5;
//     logic        deno_10;
//     logic        deno_20;
     logic        done;
     logic [1:0]  item_select;

     static logic        end_trans;
     static logic [7:0]  sum_money;   
     static logic [7:0]  price; 
       
     task init();
          reset_n        = 1;
          start          = 0;
          done_money     = 0;
          continue_buy   = 0;
          cancel         = 0;
          item_in        = 0;
          money          = 0;
//          deno_5         = 0;
//          deno_10        = 0;
//          deno_20        = 0;
     endtask;
     
     task value(
                    logic        rst_val        = 1,
                    logic        start_val      = 0,
                    logic        done_money_val = 0,
                    logic        continue_buy_val = 0,
                    logic        cancel_val     = 0,
                    logic [1:0]  item_val       = 2'b00,
                    logic [2:0]  money_val      = 3'b000
//                    logic        deno_5_val     = 0,
//                    logic        deno_10_val    = 0,
//                    logic        deno_20_val    = 0
                    );
          reset_n         = rst_val;
          start           = start_val;
          done_money      = done_money_val;
          continue_buy    = continue_buy_val;
          cancel          = cancel_val;
          item_in         = item_val;
          money           = money_val;
//          deno_5      = deno_5_val;
//          deno_10     = deno_10_val;
//          deno_20     = deno_20_val;
     endtask

     int cycle = 10;
     
     control DUT(
          .clk(clk),
     
          .reset_n(reset_n),
          .start(start),
          .done_money(done_money),
          .continue_buy(continue_buy),
          .cancel(cancel),
          .item_in(item_in),     
          .money(money), 
//          .deno_5(deno_5),
//          .deno_10(deno_10),
//          .deno_20(deno_20),

          .end_trans(end_trans),
          .sum_money(sum_money), 
          .price(price),
          .done(done),
          .item_select(item_select)
     );

     logic [1:0]      state_expect;
     logic            done_expect;
     logic            end_trans_expect;
     logic [7:0]      price_expect;
     logic [7:0]      sum_money_expect;
     logic [1:0]      item_select_expect;

     task golden();
          $display("golden run %t", $time);
          case(DUT.U2.state)
               IDLE: begin
                    case(start)
                        1'b0 : begin
                             state_expect        = IDLE;
                             done_expect         = 1'b0;
                             end_trans_expect    = 1'b0;
                             price_expect        = 8'b0;
                             sum_money_expect    = 8'b0;
                             item_select_expect  = 2'b00;     
                        end
                        1'b1 : begin
                             state_expect        = SELECT;
                             done_expect         = 1'b0;
                             end_trans_expect    = 1'b0;
                             price_expect        = 8'b0;
                             sum_money_expect    = 8'b0;
                             item_select_expect  = 2'b00;  
                        end
                        default: begin end
                    endcase
               end
               SELECT: begin
                    case({cancel, DUT.U1.out_stock})
                    2'b00 : begin
                         state_expect        = RECEIVE_MONEY;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;     
                    end
                    2'b01 : begin
                         state_expect        = SELECT;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;  
                    end
                    2'b10 : begin
                         state_expect        = IDLE;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;  
                    end                    
                    2'b11 : begin
                         state_expect        = IDLE;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;  
                    end
                    default: begin end
                    endcase
               end
               RECEIVE_MONEY: begin
                    case({cancel, done_money, (sum_money>40)})
                    3'b1xx : begin
                         state_expect        = RETURN_CHANGE;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;     
                    end
                    3'b000 : begin
                         state_expect        = RECEIVE_MONEY;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;  
                    end
                    3'b001 : begin
                         state_expect        = COMPARE;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;  
                    end                    
                    3'b010 : begin
                         state_expect        = COMPARE;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;  
                    end
                    3'b011 : begin
                         state_expect        = COMPARE;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;  
                    end
                    default: begin end
                    endcase
               end
               COMPARE: begin
                    case(DUT.U1.enough_money)
                    1'b0 : begin
                         state_expect        = PROCESS;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;     
                    end
                    1'b1 : begin
                         state_expect        = RETURN_CHANGE;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;  
                    end
                    default: begin end
                    endcase
               end
               PROCESS: begin
               case(cancel)
                    1'b0 : begin
                         state_expect        = RECEIVE_MONEY;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;     
                    end
                    1'b1 : begin
                         state_expect        = RETURN_CHANGE;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;  
                    end
                    default: begin end
                    endcase
               end
               RETURN_CHANGE: begin
                    case(continue_buy)
                    1'b0 : begin
                         state_expect        = IDLE;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;     
                    end
                    1'b1 : begin
                         state_expect        = SELECT;
                         done_expect         = 1'b0;
                         end_trans_expect    = 1'b0;
                         price_expect        = 8'b0;
                         sum_money_expect    = 8'b0;
                         item_select_expect  = 2'b00;  
                    end
                    default: begin end
                    endcase
               end
          endcase
     endtask

     task compare_output();
          $display("compare run %t", $time);
           $display("            actual\t|expect");
           $display("state:      \t%d\t|%d",DUT.U1.state,state_expect);
           $display("done:       \t%d\t|%d",done,done_expect);
           $display("end_trans:  \t%d\t|%d",end_trans, end_trans_expect);
           $display("price:      \t%d\t|%d",price,price_expect);
           $display("sum_money:  \t%d\t|%d",sum_money,sum_money_expect);
           $display("item_select:\t%d\t|%d",item_select,item_select_expect);
          if(DUT.U1.state == state_expect && done == done_expect && end_trans == end_trans_expect && price == price_expect && DUT.sum_money == sum_money_expect && item_select == item_select_expect) begin
               $display("dung roi em oi");
          end
          else begin
               $display("sai roi em oi"); 
          end
     endtask

     task state_IDLE(
          bit        start         = 0);
          value(
               .start_val(start)
          );
     endtask;

     task state_SELECT(
              bit [1:0]  item          = 2'b00
          );

          value(
               .item_val(item) 
          );
     endtask;

     task state_RECEIVE_MONEY(
          bit        done_money    = 0,
          bit        cancel        = 0,
          bit  [2:0] money         = 3'b000
//          bit        deno_5        = 0,
//          bit        deno_10       = 0,
//          bit        deno_20       = 0
          );

          value(
               .done_money_val(done_money),
               .cancel_val(cancel),
               .money_val(money)
          );
     endtask;

     task state_COMPARE();

          value();
     endtask;

     task state_PROCESS(
               bit        cancel        = 0
          );

          value(
               .cancel_val(cancel)
          );
     endtask;

     task state_RETURN_CHANGE(
               bit        continue_buy  = 0
          );

          value(
               .continue_buy_val(continue_buy)
          );
     endtask;
     
     initial begin
          clk = 0;
          forever #(cycle/2) clk = ~clk;
     end
     
     
    task reset;
        begin
            reset_n = 0;
            #10 reset_n = 1;
        end
    endtask;
     
     initial begin
          reset();
          init();
          #(cycle);
          
          state_IDLE(.start(1));
          #4 golden;
          #2 compare_output();
          #4
          
          state_SELECT(.item(2'b11));
          #4 golden;
          #2 compare_output();
          #4
          
          state_RECEIVE_MONEY(
              .done_money(1'b1),
              .money(3'b001)    
          );
          #4 golden;
          #2 compare_output();
     end
endmodule 
