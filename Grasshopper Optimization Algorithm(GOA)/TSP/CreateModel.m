function model = CreateModel()

    x = [92 76 89 6 18 74 70 78 50 42 61 86 67 52 30 71 38 57 89 85];
    y = [70 63 45 47 95 8 28 45 59 88 47 44 75 47 86 47 50 49 23 8];

    N = numel(x);
    D = zeros(N,N);
    for i=1:N-1
        for j=i:N
            D(i,j) = sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            D(j,i) = D(i,j);
        end
    end
    
    model.N = N;
    model.x = x;
    model.y = y;
    model.D = D;

end