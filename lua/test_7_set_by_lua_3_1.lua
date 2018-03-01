--用set_by_lua实现跳转
local ngx_match = ngx.re.match
local var = ngx.var
local skuId = var.skuId
local r = var.item_dynamic ~= "1" and ngx.re.match(skuId, "^[0-9]{8}$")
if r then
    return "1"
else
    return "0"
end;