Sinh viên thực hiện: Bùi Hoàng Long

Mã sinh viên: K235480106044

Lớp: K59KMTK01

<img width="2559" height="1599" alt="Ảnh chụp màn hình 2026-05-06 191342" src="https://github.com/user-attachments/assets/a2962ce5-ecf9-4125-8e9c-d4351e41ad4f" />

Chú thích: Tạo các bảng KhachHang, HopDong,... làm dữ liệu cho CSDL cầm cố. 

Event 1: Đăng ký hợp đồng mới (Vay tiền)

<img width="2559" height="1599" alt="Ảnh chụp màn hình 2026-05-06 191505" src="https://github.com/user-attachments/assets/1966f9b5-70ed-4f61-86b5-988c1f6defaf" />

Chú thích: Hình ảnh mô tả chức năng dùng để tạo mới một hợp đồng cầm đồ trong hệ thống. Khi khách đến vay tiền, hệ thống sẽ lưu thông tin khách hàng, số tiền vay, ngày tạo hợp đồng, các mốc thời hạn (Deadline1, Deadline2) và danh sách tài sản thế chấp. Sau khi thêm dữ liệu thành công, hợp đồng sẽ được gán trạng thái ban đầu là “Đang vay” để phục vụ cho việc tính lãi và quản lý công nợ về sau.

Event 2: Tính toán công nợ thời gian thực

<img width="2559" height="1599" alt="Ảnh chụp màn hình 2026-05-06 195852" src="https://github.com/user-attachments/assets/6d01dfd0-f7fd-4705-ac2f-38a84998a3c2" />

Chú thích: Tạo dữ liệu ví dụ về khách hàng và hợp đồng để tính lãi suất.

<img width="2559" height="1599" alt="Ảnh chụp màn hình 2026-05-06 200202" src="https://github.com/user-attachments/assets/00316059-6961-4e60-bd73-54e3356e577f" />

Chú thích: Hình ảnh thực hiện việc kiểm tra thông tin khách hàng, tài sản và số tiền vay trước khi lưu dữ liệu vào cơ sở dữ liệu. Tính toán các khoản vay trước và sau khi tính lãi và cập nhật vào cơ sở dữ liệu. Sau khi thông tin hợp lệ, hệ thống sẽ tạo hợp đồng và cập nhật trạng thái liên quan để phục vụ quá trình quản lý vay.

Event 3: Xử lý khoản nợ và hoàn trả tài sản

<img width="2559" height="1599" alt="Ảnh chụp màn hình 2026-05-06 200556" src="https://github.com/user-attachments/assets/04e7678c-27fb-4ccf-b15a-45e035ee1d9f" />

<img width="2559" height="1599" alt="Ảnh chụp màn hình 2026-05-06 200707" src="https://github.com/user-attachments/assets/17fd9c87-7b9e-450e-8466-8014761af066" />

Chú thích: Event 3 dùng để xác nhận hợp đồng có đủ điều kiện thanh toán trước khi cập nhật dữ liệu. Hệ thống sẽ kiểm tra mã hợp đồng có tồn tại hay không, hợp đồng đã thanh toán chưa, số tiền khách trả có hợp lệ không và có đủ để thanh toán tiền gốc cùng tiền lãi hay không. Ngoài ra hệ thống còn kiểm tra trạng thái hợp đồng để tránh thanh toán trùng hoặc xử lý sai dữ liệu. Nếu các điều kiện đều đúng thì hệ thống mới cho phép hoàn tất giao dịch và cập nhật trạng thái hợp đồng.

Event 4: Truy vấn danh sách nợ xấu

<img width="2559" height="1599" alt="Ảnh chụp màn hình 2026-05-06 200919" src="https://github.com/user-attachments/assets/a54aec32-bfd2-49fa-956e-0c573cb42d31" />
Chú thích: Quy trình hoạt động tổng quát của Event 4 gồm:

- Hệ thống tiếp nhận yêu cầu tất toán hợp đồng từ nhân viên hoặc khách hàng.

- Kiểm tra thông tin hợp đồng có tồn tại hay không.

Kiểm tra trạng thái hợp đồng:

- Nếu hợp đồng đã đóng trước đó thì không cho xử lý tiếp.

- Nếu hợp đồng còn hiệu lực thì tiếp tục thực hiện.

Kiểm tra khách hàng đã thanh toán đủ tiền gốc, lãi và các khoản phí phát sinh chưa.
Nếu chưa thanh toán đủ:

- Hệ thống báo lỗi hoặc yêu cầu thanh toán bổ sung.

Nếu đã hoàn tất:

- Cập nhật trạng thái hợp đồng thành “Đã tất toán” hoặc “Hoàn thành”.

- Cập nhật ngày kết thúc hợp đồng.

- Ghi nhận lịch sử giao dịch thanh toán.

- Giải phóng tài sản cầm cố hoặc xác nhận trả tài sản cho khách.

- Cuối cùng hệ thống thông báo xử lý thành công.

Event 5: Quản lý thanh lý tài sản

<img width="2559" height="1599" alt="Ảnh chụp màn hình 2026-05-06 201941" src="https://github.com/user-attachments/assets/33a68a3b-af5a-4e05-89d7-56fcc4255bc3" />

Chú thích: Kiểm tra khách hàng đã thanh toán chưa. Nếu chưa chuyển sang nợ xấu.

<img width="2559" height="1599" alt="Ảnh chụp màn hình 2026-05-06 202106" src="https://github.com/user-attachments/assets/4561a7e3-ac72-4c3f-aae7-ffe5f3103d4b" />

Chú thích: Kiểm tra tài sản xem khách hàng đã thanh toán chưa nếu còn nợ xấu chuyển sang thanh lý.

<img width="2559" height="1599" alt="Ảnh chụp màn hình 2026-05-06 202150" src="https://github.com/user-attachments/assets/cc49842b-bb22-4774-811e-7d98631a75c3" />

Chú thích: Nếu tài sản cầm cố đã thanh lý hiển thị đã thanh lý. 

Gia hạn hợp đồng: 

<img width="2559" height="1599" alt="Ảnh chụp màn hình 2026-05-06 202210" src="https://github.com/user-attachments/assets/25ac5be4-8fc9-422c-8841-7d2b5d45c862" />

Chú thích: Đoạn code trên tạo Stored Procedure sp_GiaHan dùng để gia hạn thời gian cho hợp đồng vay. Procedure nhận vào mã hợp đồng (@HopDongID) và số ngày cần gia hạn (@SoNgayThem). Khi thực hiện, hệ thống sẽ tự động cộng thêm số ngày này vào hai mốc thời gian Deadline1 và Deadline2 của hợp đồng tương ứng. Procedure này giúp việc gia hạn hợp đồng được thực hiện nhanh chóng và chính xác hơn.



