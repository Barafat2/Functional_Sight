data = load("edf1_part.mat");

posX = data.edf1_part.posX;

w=1;
count = 0;
j = 1;
xCount = 1;
xHigh = 0;
xMatrix = [];

for i = 1:length(posX)
    if i ~= 1
        if isnan(posX(i))
            %Count how many NaNs are in this run
            count=count+1;
        else
            if count ~= 0
                %Add to Matrix
                xMatrix(w) = count;
                w = w+ 1;
                count = 0;
            end
        end
    end
end

for i = 1:length(posX)
    if i ~= 11
        if isnan(posX(i))
            
            
            %If it's in the first half of the blink
            if xCount/2 <= xMatrix(j)
                posX(i) = posX(i-2);
                %If its in the second half of the blink
                xCount = xCount+1;
            
            
            elseif xCount/2 >= xMatrix(j)
                %Find the value at the end of the NaNs
                for k = i:length(posX)
                    if ~isnan(posX(k))
                        xHigh = posX(k+2);
                    end
                end
                %Set second half to next number
                posX(i) = xHigh;
                xCount = xCount+1;
            end
            
        end
        j = j+1;
    end
end

figure;
plot(posX)


