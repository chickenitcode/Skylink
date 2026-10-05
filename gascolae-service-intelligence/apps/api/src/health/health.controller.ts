import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { PrismaService } from '../common/prisma.service';

@ApiTags('health')
@Controller('health')
export class HealthController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  @ApiOperation({ summary: 'Health check' })
  @ApiResponse({ status: 200, description: 'Service is healthy' })
  async check() {
    let dbStatus = 'disconnected';
    let pgvectorStatus = 'unknown';
    try {
      await this.prisma.$queryRaw`SELECT 1`;
      dbStatus = 'connected';
      // Check pgvector extension
      const result = await this.prisma.$queryRaw`SELECT extname FROM pg_extension WHERE extname = 'vector'`;
      pgvectorStatus = (result as any[]).length > 0 ? 'enabled' : 'not_installed';
    } catch {
      dbStatus = 'error';
    }

    return {
      status: 'ok',
      service: 'gascolae-service-intelligence-api',
      version: '0.1.0',
      timestamp: new Date().toISOString(),
      database: dbStatus,
      pgvector: pgvectorStatus,
      environment: process.env.NODE_ENV || 'development',
    };
  }
}
