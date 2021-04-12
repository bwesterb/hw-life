module gol(
    input clk,
    input reset,
    output [WIDTH*HEIGHT-1:0] out,
    input [WIDTH*HEIGHT-1:0] in
);

    parameter WIDTH=5;
    parameter HEIGHT=5;

    reg grid[WIDTH-1:0][HEIGHT-1:0];

    genvar gx, gy;
    integer x, y;
    integer sum;
    
    wire [1:0] three_sum[WIDTH-1:0][HEIGHT-1:0];
    
    generate
        for (gx = 0; gx < WIDTH; gx=gx+1) begin
            for (gy = 0; gy < HEIGHT; gy=gy+1) begin
                assign out[gx*HEIGHT+gy] = grid[gx][gy];
            
                assign three_sum[gx][gy] = grid[gx][gy] +
                    grid[(gx+1)%WIDTH][gy] + grid[(gx+2)%WIDTH][gy];
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (reset) begin
            for (x = 0; x < WIDTH; x=x+1) begin
                for (y = 0; y < HEIGHT; y=y+1) begin
                    grid[x][y] <= in[x*HEIGHT+y];
                end
            end
        end else begin
            for (x = 0; x < WIDTH; x=x+1) begin
                for (y = 0; y < HEIGHT; y=y+1) begin
                    sum = (
                        three_sum[(x+WIDTH-1)%WIDTH][(y+HEIGHT-1)%HEIGHT] +
                        three_sum[(x+WIDTH-1)%WIDTH][(y+1)%HEIGHT] +
                        grid[(x+WIDTH-1)%WIDTH][y]+
                        grid[(x+1)%WIDTH][y]);
                        
                    if (grid[x][y]) begin
                        grid[x][y] <= (sum == 3 || sum == 2);
                    end else begin
                        grid[x][y] <= sum == 3;
                    end
                end
            end
        end
    end
endmodule
