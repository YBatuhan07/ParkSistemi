module ParkSystem(
  input clk,
  input reset_button,
  input reserve_button,
  output reg red_led,
  output reg green_led,
  output reg blue_led
);

  reg [1:0] state; // Park sistemi durumunu tutmak için 2-bitlik bir register
  reg [28:0] count; // 27 MHz clock için sayaç

  always @(posedge clk or posedge reset_button) begin
    if (reset_button) begin
      state <= 2'b00; // Reset butonuna basıldığında başlangıç durumu boş olacak
      count <= 0; // Reset durumunda sayaç sıfırlanacak
    end else begin
      case (state)
        2'b00: begin // Durum 0 - Park yeri boş
          if (reserve_button) begin
            state <= 2'b01; // Rezerve durumuna geçiş
            count <= 0; // Rezerve durumuna geçtiğimizde sayaç sıfırlanacak
          end
        end

        2'b01: begin // Durum 1 - Park yeri rezerve edildi
          if (count == 270_000_000) begin // 10 saniye bekleniyor (27 MHz için)
            state <= 2'b10; // Dolu durumuna geçiş
          end else begin
            count <= count + 1; // Sayaç artırılıyor
          end
        end

        2'b10: begin // Durum 2 - Park yeri dolu
         
        end
      endcase
    end
  end


  always @(*) begin
    case (state)
      2'b00: begin // Durum 0 - Park yeri boş
        red_led   = 1'b1;
        green_led = 1'b0;
        blue_led  = 1'b1;
      end

      2'b01: begin // Durum 1 - Park yeri rezerve edildi
        red_led   = 1'b1;
        green_led = 1'b1;
        blue_led  = 1'b0;
      end

      2'b10: begin // Durum 2 - Park yeri dolu
        red_led   = 1'b0;
        green_led = 1'b1;
        blue_led  = 1'b1;
      end
    endcase
  end

endmodule
