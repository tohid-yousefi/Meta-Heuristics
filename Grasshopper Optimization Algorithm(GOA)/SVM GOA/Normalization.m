function X = Normalization(X)

    MinX = min(X);
    MaxX = max(X);

    for i=1:numel(MinX)
        X(:,i) = 2*(X(:,i) - MinX(i)) / (MaxX(i) - MinX(i))-1;
    end

end