// src/main/java/com/example/pmember/controller/MypageController.java
package com.example.pmember.controller;

import com.example.pmember.dto.Pmember;
import com.example.pmember.dto.WishItem;
import com.example.pmember.dto.Dislike;
import com.example.pmember.dto.Alergy;
import com.example.pmember.dto.FoodRecommendation;
import com.example.pmember.dto.BeverageRecommendation;
import com.example.pmember.service.PmemberMapper;
import com.example.pmember.service.WishlistMapper;
import com.example.pmember.service.DislikeMapper;
import com.example.pmember.service.AlergyMapper;
import com.example.pmember.service.FoodRecommendationMapper;
import com.example.pmember.service.BeverageRecommendationMapper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@Controller
public class MypageController {

    @Autowired
    private PmemberMapper memberMapper;

    @Autowired
    private WishlistMapper wishlistMapper;

    @Autowired
    private DislikeMapper dislikeMapper;   // 🔹 벤 메뉴용

    // 🔹 알레르기 마스터 / 회원 알레르기 조회용
    @Autowired
    private AlergyMapper alergyMapper;

    // 🔹 음식/음료 추천 기록 Mapper
    @Autowired
    private FoodRecommendationMapper foodRecommendationMapper;

    @Autowired
    private BeverageRecommendationMapper beverageRecommendationMapper;

    // 실제 이미지 저장 경로 (원하는 곳으로 변경 가능)
    private final String uploadDir = "C:/upload/profile/";

    // 🔵 마이페이지 화면
    @GetMapping("/mypage")
    public String mypage(HttpSession session, Model model) {

        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login == null) {
            return "redirect:/login";
        }

        // DB 최신 정보 다시 가져오기 (이미지 포함)
        Pmember fresh = memberMapper.findFullById(login.getId());
        if (fresh == null) {
            // 혹시라도 조회 실패하면 기존 세션 값이라도 사용
            fresh = login;
        }

        String memberId = fresh.getId();

        // 상단 프로필/정보
        model.addAttribute("nickname", memberId);
        model.addAttribute("email", fresh.getEmail());
        model.addAttribute("profileImage", fresh.getProfileImage());

        // 🔹 찜 목록 조회
        List<WishItem> wishlist = wishlistMapper.selectWishlistByMember(memberId);
        model.addAttribute("wishlist", wishlist);

        // 🔹 벤(싫어요) 목록 조회
        List<Dislike> dislikeList = dislikeMapper.selectDislikeList(memberId);
        model.addAttribute("dislikeList", dislikeList);

        // 🔹 알레르기 마스터 전체 (p_alergy) → JSP의 ${alergyList}
        List<Alergy> alergyList = alergyMapper.selectAllAlergy();
        model.addAttribute("alergyList", alergyList);

        // 🔹 현재 회원이 체크해 둔 알레르기 al_idx 목록 → JSP의 ${userAlergyIdxList}
        List<Integer> userAlergyIdxList = alergyMapper.selectUserAlergyIdxList(memberId);
        model.addAttribute("userAlergyIdxList", userAlergyIdxList);

        // 🔹 음식/음료 추천 기록 (최근 30건 정도)
        List<FoodRecommendation> foodHistoryList =
                foodRecommendationMapper.findRecentFoodRecommendations(memberId);
        List<BeverageRecommendation> beverageHistoryList =
                beverageRecommendationMapper.findRecentBeverageRecommendations(memberId);

        model.addAttribute("foodHistoryList", foodHistoryList);
        model.addAttribute("beverageHistoryList", beverageHistoryList);

        // 세션도 최신 정보로 갱신
        session.setAttribute("loginMember", fresh);

        return "mypage";
    }

    // 🔵 프로필 이미지 업로드 처리
    @PostMapping("/mypage/profile-image")
    public String uploadProfile(@RequestParam("file") MultipartFile file,
                                HttpSession session) {

        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login == null) return "redirect:/login";

        if (file.isEmpty()) return "redirect:/mypage";

        try {
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            String original = file.getOriginalFilename();
            String ext = "";
            if (original != null && original.lastIndexOf(".") != -1) {
                ext = original.substring(original.lastIndexOf("."));
            }

            String savedName = UUID.randomUUID() + ext;
            File savedFile = new File(dir, savedName);
            file.transferTo(savedFile);

            // 웹에서 접근 가능한 경로
            String webPath = "/profile/" + savedName;

            // DB 저장
            memberMapper.updateProfileImage(login.getId(), webPath);

            // 세션 갱신
            login.setProfileImage(webPath);
            session.setAttribute("loginMember", login);

        } catch (IOException e) {
            e.printStackTrace();
        }

        return "redirect:/mypage";
    }

    // 🔵 회원 정보 수정 화면
    @GetMapping("/mypage/edit")
    public String editMypage(HttpSession session, Model model) {

        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login == null) {
            return "redirect:/login";
        }

        // 최신 회원 정보 다시 조회
        Pmember fresh = memberMapper.findFullById(login.getId());
        if (fresh == null) {
            fresh = login;
        }

        // mypage_edit.jsp에서 사용하는 member
        model.addAttribute("member", fresh);

        // 🔹 birth: "1990-01-01" → year / month / day 분리해서 전달
        if (fresh.getBirth() != null && fresh.getBirth().length() >= 10) {
            String[] parts = fresh.getBirth().split("-");
            if (parts.length == 3) {
                try {
                    String year  = parts[0];
                    String month = String.valueOf(Integer.parseInt(parts[1])); // "01" → "1"
                    String day   = String.valueOf(Integer.parseInt(parts[2])); // "09" → "9"

                    model.addAttribute("birthYear", year);
                    model.addAttribute("birthMonth", month);
                    model.addAttribute("birthDay", day);
                } catch (NumberFormatException e) {
                    model.addAttribute("birthYear", null);
                    model.addAttribute("birthMonth", null);
                    model.addAttribute("birthDay", null);
                }
            }
        }

        // 세션도 최신 정보로 갱신
        session.setAttribute("loginMember", fresh);

        return "mypage_edit";   // 🔹 /WEB-INF/views/mypage_edit.jsp
    }

    // 🔵 회원 정보 수정 처리
    @PostMapping("/mypage/update")
    public String updateMypage(
            @RequestParam("oldId") String oldId,
            @RequestParam("id") String id,
            @RequestParam("email") String email,
            @RequestParam(value = "pw", required = false) String pw,
            @RequestParam(value = "pw2", required = false) String pw2,
            @RequestParam(value = "birthYear", required = false) String birthYear,
            @RequestParam(value = "birthMonth", required = false) String birthMonth,
            @RequestParam(value = "birthDay", required = false) String birthDay,
            @RequestParam(value = "gender", required = false) String gender,
            HttpSession session,
            Model model
    ) {

        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login == null) {
            return "redirect:/login";
        }

        // 🔹 기본 검증: 아이디/이메일은 비어 있으면 안 됨
        if (id == null || id.isBlank()) {
            model.addAttribute("updateError", "아이디는 비워 둘 수 없습니다.");
            return editMypage(session, model);
        }
        if (email == null || email.isBlank()) {
            model.addAttribute("updateError", "이메일은 비워 둘 수 없습니다.");
            return editMypage(session, model);
        }

        // 🔹 생년월일 문자열 조합 (YYYY-MM-DD) - 세 개 다 있으면만 세팅
        String birth = null;
        if (birthYear != null && !birthYear.isBlank()
                && birthMonth != null && !birthMonth.isBlank()
                && birthDay != null && !birthDay.isBlank()) {

            String mm = birthMonth.length() == 1 ? "0" + birthMonth : birthMonth;
            String dd = birthDay.length() == 1 ? "0" + birthDay : birthDay;
            birth = birthYear + "-" + mm + "-" + dd;
        }

        // 🔹 gender 기본값 보정
        if (gender == null || gender.isBlank()) {
            gender = "private";
        }

        // 🔹 수정용 Pmember 객체 생성
        Pmember member = new Pmember();
        member.setId(id);
        member.setEmail(email);
        member.setBirth(birth);
        member.setGender(gender);

        // 프로필 이미지는 지금 변경 안하므로 기존 세션값 유지
        member.setProfileImage(login.getProfileImage());

        boolean changePw = (pw != null && !pw.isBlank());

        // 비밀번호 변경 요청 → pw/pw2 일치 확인
        if (changePw) {
            if (pw2 == null || !pw.equals(pw2)) {
                model.addAttribute("updateError", "비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                // 다시 폼 보여줄 때 기존 값 채워주기 위해
                model.addAttribute("member", member);
                if (birth != null && birth.length() >= 10) {
                    String[] parts = birth.split("-");
                    if (parts.length == 3) {
                        model.addAttribute("birthYear", parts[0]);
                        model.addAttribute("birthMonth", String.valueOf(Integer.parseInt(parts[1])));
                        model.addAttribute("birthDay", String.valueOf(Integer.parseInt(parts[2])));
                    }
                }
                return "mypage_edit";
            }
            member.setPw(pw);  // 새 비번 세팅
        }

        int updated;
        if (changePw) {
            updated = memberMapper.updateMemberWithPw(oldId, member);
        } else {
            updated = memberMapper.updateMemberNoPw(oldId, member);
        }

        if (updated > 0) {
            // 🔹 DB에서 최신 정보 다시 읽어서 세션/모델 반영
            Pmember fresh = memberMapper.findFullById(member.getId());
            if (fresh == null) {
                fresh = member;
            }
            session.setAttribute("loginMember", fresh);

            model.addAttribute("updateSuccess", "회원 정보가 수정되었습니다.");
            model.addAttribute("member", fresh);

            // 생년월일 다시 분해해서 셀렉트 박스 유지
            if (fresh.getBirth() != null && fresh.getBirth().length() >= 10) {
                String[] parts = fresh.getBirth().split("-");
                if (parts.length == 3) {
                    try {
                        String year  = parts[0];
                        String month = String.valueOf(Integer.parseInt(parts[1]));
                        String day   = String.valueOf(Integer.parseInt(parts[2]));
                        model.addAttribute("birthYear", year);
                        model.addAttribute("birthMonth", month);
                        model.addAttribute("birthDay", day);
                    } catch (NumberFormatException e) {
                        model.addAttribute("birthYear", null);
                        model.addAttribute("birthMonth", null);
                        model.addAttribute("birthDay", null);
                    }
                }
            }

            // ✅ 수정 후에도 같은 페이지에서 성공 메시지 보여줌
            return "mypage_edit";
        } else {
            model.addAttribute("updateError", "회원 정보 수정에 실패했습니다. 다시 시도해 주세요.");
            model.addAttribute("member", member);
            return "mypage_edit";
        }
    }

    // 🔵 음식 추천 기록 선택 삭제
    @PostMapping("/mypage/history/food/delete")
    public String deleteFoodHistory(
            @RequestParam(value = "recoIdx", required = false) List<Integer> recoIdxList,
            HttpSession session
    ) {
        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login == null) {
            return "redirect:/login";
        }
        if (recoIdxList == null || recoIdxList.isEmpty()) {
            return "redirect:/mypage?tab=history";
        }

        foodRecommendationMapper.deleteFoodRecommendations(login.getId(), recoIdxList);
        return "redirect:/mypage?tab=history";
    }

    // 🔵 음료 추천 기록 선택 삭제
    @PostMapping("/mypage/history/beverage/delete")
    public String deleteBeverageHistory(
            @RequestParam(value = "recoBevIdx", required = false) List<Integer> recoIdxList,
            HttpSession session
    ) {
        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login == null) {
            return "redirect:/login";
        }
        if (recoIdxList == null || recoIdxList.isEmpty()) {
            return "redirect:/mypage?tab=history";
        }

        beverageRecommendationMapper.deleteBeverageRecommendations(login.getId(), recoIdxList);
        return "redirect:/mypage?tab=history";
    }
}
