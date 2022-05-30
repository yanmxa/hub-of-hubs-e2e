
.PHONY: e2e
e2e: fmt
	@echo "Running the E2E Tests..."
	@./cicd-scripts/run-e2e-tests.sh

.PHONY: fmt				
fmt:
	@gci -w ./pkg/
	@go fmt ./pkg/...
	@gofumpt -w ./pkg/

.PHONY: vendor			
vendor:
	@go mod vendor

.PHONY: clean-vendor		
clean-vendor:
	-@rm -rf vendor