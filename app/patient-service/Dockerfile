FROM public.ecr.aws/lambda/nodejs:20

COPY package*.json ./
RUN npm ci --omit=dev

COPY src/ ${LAMBDA_TASK_ROOT}/

CMD ["src/handler.handler"]
