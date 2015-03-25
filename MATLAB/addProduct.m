function productcost = addProduct(productName) 
    fdir = fullfile(pwd,'menu',char(productName));
    if(exist(fdir,'file') ~= 2)
        productcost = 0;
        return;
    end
    productcost = dlmread(fdir);
end