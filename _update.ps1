# ===== 사용자 설정 =====
# GitHub 저장소
$repo = "MZ-Prj/MZ.Xray.Setup"
# 릴리스 태그
$tag = "xray-setup-v1.0.0"  
# 릴리스 제목                      
$title = "Xray Setup v1.0.0"                 
# 릴리스 설명     
$notes = "Initial release of Xray Setup"       
# 업로드할 데이터 파일 (상대 경로)
$filePath1 = "Datas\AppSetup.msi"               
$filePath2 = "Datas\ProducerSetup.msi"              
# ========================

# 현재 스크립트 디렉토리 기준으로 절대 경로 만들기
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$filePath1 = Join-Path $scriptDir $filePath1 
$filePath2 = Join-Path $scriptDir $filePath2 

# Git 상태 확인
Write-Host "🔍 현재 Git 상태 확인..."
git status

# 태그 존재 여부 확인
$existingTag = git tag --list $tag

if ($existingTag) {
    Write-Host "⚠️ 태그 '$tag' 는 이미 존재합니다. 건너뜁니다."
} else {
    # 태그 만들기 및 푸시
    Write-Host "🏷️ Git 태그 '$tag' 생성..."
    git tag $tag
    git push origin $tag
}

# 릴리스 만들기
Write-Host "🚀 GitHub 릴리스 '$tag' 생성 시도..."
try {
    gh release create $tag $filePath1 $filePath2 `
        --repo $repo `
        --title $title `
        --notes $notes `
        --verify-tag
} catch {
    Write-Host "⚠️ 릴리스 생성 실패 또는 이미 존재함. 기존 릴리스에 업로드 시도."
}

# 파일 업로드 (첫 번째 파일)
Write-Host "📦 첫 번째 파일 릴리스에 업로드 중: $filePath1"
gh release upload $tag $filePath1 `
    --repo $repo `
    --clobber

# 파일 업로드 (두 번째 파일)
Write-Host "📦 두 번째 파일 릴리스에 업로드 중: $filePath2"
gh release upload $tag $filePath2 `
    --repo $repo `
    --clobber


Write-Host "`n✅ 완료! 릴리스 링크:"
Write-Host "🔗 https://github.com/$repo/releases/tag/$tag"