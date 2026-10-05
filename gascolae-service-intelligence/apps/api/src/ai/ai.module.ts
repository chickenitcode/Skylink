import { Module } from '@nestjs/common';
import { AiService } from './ai.service';
import { GeminiProvider } from './providers/gemini/gemini.provider';
import { MockProvider } from './providers/mock/mock.provider';

@Module({
  providers: [AiService, GeminiProvider, MockProvider],
  exports: [AiService],
})
export class AiModule {}
