local M

local b64_t = {
    [0]='A',[1]='B',[2]='C',[3]='D',[4]='E',[5]='F',[6]='G',[7]='H',[8]='I',
    [9]='J',[10]='K',[11]='L',[12]='M',[13]='N',[14]='O',[15]='P',[16]='Q',
    [17]='R',[18]='S',[19]='T',[20]='U',[21]='V',[22]='W',[23]='X',[24]='Y',
    [25]='Z',[26]='a',[27]='b',[28]='c',[29]='d',[30]='e',[31]='f',[32]='g',
    [33]='h',[34]='i',[35]='j',[36]='k',[37]='l',[38]='m',[39]='n',[40]='o',
    [41]='p',[42]='q',[43]='r',[44]='s',[45]='t',[46]='u',[47]='v',[48]='w',
    [49]='x',[50]='y',[51]='z',[52]='0',[53]='1',[54]='2',[55]='3',[56]='4',
    [57]='5',[58]='6',[59]='7',[60]='8',[61]='9',[62]='-',[63]='/'}

local function hex2b64c(c)
    local n = tonumber(c:sub(3,3), 16) + 16 * tonumber(c:sub(2,2), 16) + 16^2 * tonumber(c:sub(1,1), 16)
    local b64_a, b64_b = 0, 0
    if (n > 63) then
        b64_a = math.floor(n / 64)
        n = n - b64_a * 64
    end
    b64_b = n
    return b64_t[b64_a] .. b64_t[b64_b]
end

local function hextob64(str)
    local padding = (#str / 2) % 3
    local tail = str:sub(#str - (3 - padding) + 1, #str).. str.rep('0', padding)
    local head = str:sub(1, #str - (3 - padding)) 
    return head:gsub('%x%x%x', hex2b64c) .. tail:gsub('%x%x%x', hex2b64c):gsub('A', '=')
end

M = {
    hextob64 = hextob64
}

return M
