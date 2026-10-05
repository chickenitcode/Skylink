import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Bắt đầu nạp dữ liệu Seed...');

  // 1. Khởi tạo Roles
  const rolesData = [
    { name: 'SALES', description: 'Nhân viên kinh doanh / Phát triển dịch vụ' },
    { name: 'REVIEWER', description: 'Quản lý phê duyệt Proposal' },
    { name: 'ADMIN', description: 'Quản trị viên hệ thống' },
  ];
  
  for (const role of rolesData) {
    await prisma.role.upsert({
      where: { name: role.name },
      update: {},
      create: role,
    });
  }
  console.log('✅ Khởi tạo Roles thành công.');

  const salesRole = await prisma.role.findUnique({ where: { name: 'SALES' } });
  const adminRole = await prisma.role.findUnique({ where: { name: 'ADMIN' } });
  const reviewerRole = await prisma.role.findUnique({ where: { name: 'REVIEWER' } });

  // 2. Khởi tạo Users
  const passwordHash = await bcrypt.hash('SecurePassword@2026', 10);
  
  const users = [
    {
      id: 'usr_sales_01',
      email: 'giap.mt@gascolae.ctgroupvietnam.com',
      password_hash: passwordHash,
      full_name: 'Mai Tấn Giáp',
      department: 'Phòng KD Không Phận',
      role_id: salesRole!.id
    },
    {
      id: 'usr_admin_01',
      email: 'khang.lp@gascolae.ctgroupvietnam.com',
      password_hash: passwordHash,
      full_name: 'Lê Phúc Khang',
      department: 'Phòng Kỹ Thuật Hệ Thống',
      role_id: adminRole!.id
    },
    {
      id: 'usr_reviewer_01',
      email: 'son.nqg@gascolae.ctgroupvietnam.com',
      password_hash: passwordHash,
      full_name: 'Nguyễn Quyết Giang Sơn',
      department: 'Ban Giám Đốc',
      role_id: reviewerRole!.id
    }
  ];

  for (const u of users) {
    const user = await prisma.user.upsert({
      where: { email: u.email },
      update: {},
      create: {
        id: u.id,
        email: u.email,
        password_hash: u.password_hash,
        full_name: u.full_name,
        department: u.department,
      },
    });
    
    // Gán role
    await prisma.userRole.upsert({
      where: {
        user_id_role_id: {
          user_id: user.id,
          role_id: u.role_id,
        }
      },
      update: {},
      create: {
        user_id: user.id,
        role_id: u.role_id,
      }
    });
  }
  console.log('✅ Khởi tạo Users thành công.');

  // 3. Khởi tạo Service Mock (S0112)
  const service = await prisma.service.upsert({
    where: { id: 'S0112' },
    update: {},
    create: {
      id: 'S0112',
      service_name: 'Dịch vụ Giám sát Không phận Nông nghiệp Công nghệ cao',
      domain: 'agriculture',
      overview: 'Dịch vụ ứng dụng công nghệ máy bay không người lái cánh bằng và cảm biến quang phổ hiện đại nhằm tự động hóa công tác giám sát nông nghiệp quy mô công nghiệp.',
      short_description: 'Giải pháp Drone tầm xa quét cảm biến đa phổ Multispectral NDVI phát hiện sâu bệnh sớm trên nông trường diện tích lớn.',
      status: 'verified',
      is_mock: true,
    }
  });

  // 4. Khởi tạo Chunks Mock
  const chunks = [
    {
      id: 'CHK_S0112_CAP_a12f9b8c',
      service_id: 'S0112',
      record_type: 'capability',
      content: 'Sử dụng Drone cánh bằng tầm xa tích hợp cảm biến đa phổ Multispectral NDVI 5 dải sóng, năng lực quét tối đa 1.000 ha/ngày trên địa hình đồi dốc.',
      status: 'verified',
      visibility: 'internal',
      is_mock: true,
    },
    {
      id: 'CHK_S0112_PROB_7c4d1e2a',
      service_id: 'S0112',
      record_type: 'customer_problem',
      content: 'Khó phát hiện sâu bệnh trên nông trường cao su rộng hàng trăm hecta bằng tuần tra mặt đất. Giải quyết tình trạng phát hiện trễ sâu bệnh trên nông trường cao su nhờ thuật toán AI phân loại điểm bất thường.',
      status: 'verified',
      visibility: 'internal',
      is_mock: true,
    }
  ];

  for (const chunk of chunks) {
    await prisma.knowledgeChunk.upsert({
      where: { id: chunk.id },
      update: {},
      create: chunk,
    });
  }
  console.log('✅ Khởi tạo Service & Knowledge Chunks thành công.');
  console.log('🌱 Nạp dữ liệu Seed hoàn tất!');
}

main()
  .catch((e) => {
    console.error('❌ Lỗi khi nạp Seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
