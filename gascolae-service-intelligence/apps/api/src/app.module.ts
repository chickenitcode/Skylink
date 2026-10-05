import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { HealthModule } from './health/health.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { RolesModule } from './roles/roles.module';
import { ServicesModule } from './services/services.module';
import { KnowledgeModule } from './knowledge/knowledge.module';
import { RetrievalModule } from './retrieval/retrieval.module';
import { ConsultationModule } from './consultation/consultation.module';
import { RequirementsModule } from './requirements/requirements.module';
import { MatchingModule } from './matching/matching.module';
import { ProposalsModule } from './proposals/proposals.module';
import { ReviewsModule } from './reviews/reviews.module';
import { DocumentsModule } from './documents/documents.module';
import { AiModule } from './ai/ai.module';
import { GuardrailsModule } from './guardrails/guardrails.module';
import { WorkflowModule } from './workflow/workflow.module';
import { AuditModule } from './audit/audit.module';
import { PrismaModule } from './common/prisma.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env', '.env.development'],
    }),
    PrismaModule,
    HealthModule,
    AuthModule,
    UsersModule,
    RolesModule,
    ServicesModule,
    KnowledgeModule,
    RetrievalModule,
    ConsultationModule,
    RequirementsModule,
    MatchingModule,
    ProposalsModule,
    ReviewsModule,
    DocumentsModule,
    AiModule,
    GuardrailsModule,
    WorkflowModule,
    AuditModule,
  ],
})
export class AppModule {}
