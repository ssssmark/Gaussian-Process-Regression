import csv
from datetime import datetime

# 打开CSV文件并读取数据
with open('vrsn.csv', 'r') as file:
    reader = csv.reader(file)
    data = list(reader)

# 按照日期升序排序数据
data_sorted = sorted(data, key=lambda x: datetime.strptime(x[0], '%m/%d/%Y'))

# 迭代每一行数据并转换日期格式
for row in data_sorted:
    # 使用strptime函数解析原始日期字符串
    date = datetime.strptime(row[0], '%m/%d/%Y')
    # 使用strftime函数将日期格式化为新的格式
    row[0] = date.strftime('%Y-%m-%d')

# 将转换后的数据写回到CSV文件中
with open('vrsn_sorted_and_converted.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(data_sorted)
