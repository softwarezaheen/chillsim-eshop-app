/// Represents different types of bundles with serialization support
enum BundleType {
  global("global"),
  regional("regional"),
  country("country");

  const BundleType(this.type);

  final String type;

  /// Creates a [BundleType] from a string value
  /// Returns null if no matching type is found
  static BundleType? fromString(String value) {
    return BundleType.values.cast<BundleType?>().firstWhere(
          (BundleType? type) => type!.type.toLowerCase() == value.toLowerCase(),
          orElse: () => null,
        );
  }

  /// Gets the string representation of the bundle type
  @override
  String toString() => type;
}

// /// Utility class for retrieving flag resources based on region or country codes.
// class FlagUtil {
//   /// Returns the flag asset path based on the provided code and type.
//   ///
//   /// [code] The region code or ISO 3166-1 alpha-3 country code.
//   /// [type] The type of the item (Regions or Countries).
//   static String getFlagAsset(String code, BundleType type) {
//     switch (type) {
//       case BundleType.regional:
//         return _getRegionFlagAsset(code);
//       case BundleType.country:
//         return _getCountryFlagAsset(code);
//       default:
//         return "assets/flags/ic_globe.svg"; // Default flag if type is not recognized
//     }
//   }
//
//   /// Returns the flag asset path for a region based on the provided region code.
//   ///
//   /// [regionCode] The code of the region.
//   static String _getRegionFlagAsset(String regionCode) {
//     switch (regionCode.toLowerCase()) {
//       case "af":
//         return "assets/flags/flag_af.svg";
//       case "as":
//         return "assets/flags/flag_me.svg";
//       case "eu":
//         return "assets/flags/flag_eu.svg";
//       case "me":
//         return "assets/flags/flag_me.svg";
//       case "na":
//         return "assets/flags/flag_na.svg";
//       case "sa":
//         return "assets/flags/flag_sa.svg";
//       case "au":
//         return "assets/flags/flag_au.svg";
//       case "oc":
//         return "assets/flags/flag_au.svg";
//       default:
//         return "assets/flags/ic_globe.svg";
//     }
//   }
//
//   /// Returns the flag asset path for a country based on the provided ISO 3166-1 alpha-3 country code.
//   ///
//   /// [isoCode3] The ISO 3166-1 alpha-3 code of the country.
//   static String _getCountryFlagAsset(String isoCode3) {
//     switch (isoCode3.toUpperCase()) {
//       case "AFG":
//         return "assets/flags/flag_afg.svg";
//       case "ALA":
//         return "assets/flags/flag_ala.svg";
//       case "ALB":
//         return "assets/flags/flag_alb.svg";
//       case "DZA":
//         return "assets/flags/flag_dza.svg";
//       case "ASM":
//         return "assets/flags/flag_asm.svg";
//       case "AND":
//         return "assets/flags/flag_and.svg";
//       case "AGO":
//         return "assets/flags/flag_ago.svg";
//       case "AIA":
//         return "assets/flags/flag_aia.svg";
//       case "ATA":
//         return "assets/flags/ic_globe.svg"; // TODO: Replace
//       case "ATG":
//         return "assets/flags/flag_atg.svg";
//       case "ARG":
//         return "assets/flags/flag_arg.svg";
//       case "ARM":
//         return "assets/flags/flag_arm.svg";
//       case "ABW":
//         return "assets/flags/flag_abw.svg";
//       case "AUS":
//         return "assets/flags/flag_aus.svg";
//       case "AUT":
//         return "assets/flags/flag_aut.svg";
//       case "AZE":
//         return "assets/flags/flag_aze.svg";
//       case "BHS":
//         return "assets/flags/flag_bhs.svg";
//       case "BHR":
//         return "assets/flags/flag_bhr.svg";
//       case "BGD":
//         return "assets/flags/flag_bgd.svg";
//       case "BRB":
//         return "assets/flags/flag_brb.svg";
//       case "BLR":
//         return "assets/flags/flag_blr.svg";
//       case "BEL":
//         return "assets/flags/flag_bel.svg";
//       case "BLZ":
//         return "assets/flags/flag_blz.svg";
//       case "BEN":
//         return "assets/flags/flag_ben.svg";
//       case "BMU":
//         return "assets/flags/flag_bmu.svg";
//       case "BTN":
//         return "assets/flags/flag_btn.svg";
//       case "BOL":
//         return "assets/flags/flag_bol.svg";
//       case "BES":
//         return "assets/flags/flag_bes.svg";
//       case "BIH":
//         return "assets/flags/flag_bih.svg";
//       case "BWA":
//         return "assets/flags/flag_bwa.svg";
//       case "BVT":
//         return "assets/flags/flag_bvt.svg";
//       case "BRA":
//         return "assets/flags/flag_bra.svg";
//       case "IOT":
//         return "assets/flags/flag_iot.svg";
//       case "BRN":
//         return "assets/flags/flag_brn.svg";
//       case "BGR":
//         return "assets/flags/flag_bgr.svg";
//       case "BFA":
//         return "assets/flags/flag_bfa.svg";
//       case "BDI":
//         return "assets/flags/flag_bdi.svg";
//       case "CPV":
//         return "assets/flags/flag_cpv.svg";
//       case "KHM":
//         return "assets/flags/flag_khm.svg";
//       case "CMR":
//         return "assets/flags/flag_cmr.svg";
//       case "CAN":
//         return "assets/flags/flag_can.svg";
//       case "CYM":
//         return "assets/flags/flag_cym.svg";
//       case "CAF":
//         return "assets/flags/flag_caf.svg";
//       case "TCD":
//         return "assets/flags/flag_tcd.svg";
//       case "CHL":
//         return "assets/flags/flag_chl.svg";
//       case "CHN":
//         return "assets/flags/flag_chn.svg";
//       case "CXR":
//         return "assets/flags/flag_cxr.svg";
//       case "CCK":
//         return "assets/flags/flag_cck.svg";
//       case "COL":
//         return "assets/flags/flag_col.svg";
//       case "COM":
//         return "assets/flags/flag_com.svg";
//       case "COG":
//         return "assets/flags/flag_cod.svg";
//       case "COD":
//         return "assets/flags/flag_cod.svg";
//       case "COK":
//         return "assets/flags/flag_cok.svg";
//       case "CRI":
//         return "assets/flags/flag_cri.svg";
//       case "CIV":
//         return "assets/flags/flag_irl.svg";
//       case "HRV":
//         return "assets/flags/flag_hrv.svg";
//       case "CUB":
//         return "assets/flags/flag_cub.svg";
//       case "CUW":
//         return "assets/flags/flag_cuw.svg";
//       case "CYP":
//         return "assets/flags/flag_cyp.svg";
//       case "CZE":
//         return "assets/flags/flag_cze.svg";
//       case "DNK":
//         return "assets/flags/flag_dnk.svg";
//       case "DJI":
//         return "assets/flags/flag_dji.svg";
//       case "DMA":
//         return "assets/flags/flag_dma.svg";
//       case "DOM":
//         return "assets/flags/flag_dom.svg";
//       case "ECU":
//         return "assets/flags/flag_ecu.svg";
//       case "EGY":
//         return "assets/flags/flag_egy.svg";
//       case "SLV":
//         return "assets/flags/flag_slv.svg";
//       case "GNQ":
//         return "assets/flags/flag_gnq.svg";
//       case "ERI":
//         return "assets/flags/flag_eri.svg";
//       case "EST":
//         return "assets/flags/flag_est.svg";
//       case "SWZ":
//         return "assets/flags/flag_swz.svg";
//       case "ETH":
//         return "assets/flags/flag_eth.svg";
//       case "FLK":
//         return "assets/flags/flag_flk.svg";
//       case "FRO":
//         return "assets/flags/flag_fro.svg";
//       case "FJI":
//         return "assets/flags/flag_fji.svg";
//       case "FIN":
//         return "assets/flags/flag_fin.svg";
//       case "FRA":
//         return "assets/flags/flag_fra.svg";
//       case "GUF":
//         return "assets/flags/flag_fra.svg";
//       case "PYF":
//         return "assets/flags/flag_pyf.svg";
//       case "ATF":
//         return "assets/flags/flag_fra.svg";
//       case "GAB":
//         return "assets/flags/flag_gab.svg";
//       case "GMB":
//         return "assets/flags/flag_gmb.svg";
//       case "GEO":
//         return "assets/flags/flag_geo.svg";
//       case "DEU":
//         return "assets/flags/flag_deu.svg";
//       case "GHA":
//         return "assets/flags/flag_gha.svg";
//       case "GIB":
//         return "assets/flags/flag_gib.svg";
//       case "GRC":
//         return "assets/flags/flag_grc.svg";
//       case "GRL":
//         return "assets/flags/flag_grl.svg";
//       case "GRD":
//         return "assets/flags/flag_grd.svg";
//       case "GLP":
//         return "assets/flags/flag_fra.svg";
//       case "GUM":
//         return "assets/flags/flag_gum.svg";
//       case "GTM":
//         return "assets/flags/flag_gtm.svg";
//       case "GGY":
//         return "assets/flags/flag_ggy.svg";
//       case "GIN":
//         return "assets/flags/flag_gin.svg";
//       case "GNB":
//         return "assets/flags/flag_gnb.svg";
//       case "GUY":
//         return "assets/flags/flag_guy.svg";
//       case "HTI":
//         return "assets/flags/flag_hti.svg";
//       case "HMD":
//         return "assets/flags/flag_hmd.svg";
//       case "VAT":
//         return "assets/flags/flag_ita.svg";
//       case "HND":
//         return "assets/flags/flag_hnd.svg";
//       case "HKG":
//         return "assets/flags/flag_hkg.svg";
//       case "HUN":
//         return "assets/flags/flag_hun.svg";
//       case "ISL":
//         return "assets/flags/flag_isl.svg";
//       case "IND":
//         return "assets/flags/flag_ind.svg";
//       case "IDN":
//         return "assets/flags/flag_idn.svg";
//       case "IRN":
//         return "assets/flags/flag_irn.svg";
//       case "IRQ":
//         return "assets/flags/flag_irq.svg";
//       case "IRL":
//         return "assets/flags/flag_irl.svg";
//       case "IMN":
//         return "assets/flags/flag_imn.svg";
//       case "ISR":
//         return "assets/flags/ic_globe.svg"; // TODO: Replace
//       case "ITA":
//         return "assets/flags/flag_ita.svg";
//       case "JAM":
//         return "assets/flags/flag_jam.svg";
//       case "JPN":
//         return "assets/flags/flag_jpn.svg";
//       case "JEY":
//         return "assets/flags/flag_jey.svg";
//       case "JOR":
//         return "assets/flags/flag_jor.svg";
//       case "KAZ":
//         return "assets/flags/flag_kaz.svg";
//       case "KEN":
//         return "assets/flags/flag_ken.svg";
//       case "KIR":
//         return "assets/flags/flag_kir.svg";
//       case "PRK":
//         return "assets/flags/flag_prk.svg";
//       case "KOR":
//         return "assets/flags/flag_kor.svg";
//       case "KWT":
//         return "assets/flags/flag_kwt.svg";
//       case "KGZ":
//         return "assets/flags/flag_kgz.svg";
//       case "LAO":
//         return "assets/flags/flag_lao.svg";
//       case "LVA":
//         return "assets/flags/flag_lva.svg";
//       case "LBN":
//         return "assets/flags/flag_lbn.svg";
//       case "LSO":
//         return "assets/flags/flag_lso.svg";
//       case "LBR":
//         return "assets/flags/flag_lbr.svg";
//       case "LBY":
//         return "assets/flags/flag_lby.svg";
//       case "LIE":
//         return "assets/flags/flag_lie.svg";
//       case "LTU":
//         return "assets/flags/flag_ltu.svg";
//       case "LUX":
//         return "assets/flags/flag_lux.svg";
//       case "MAC":
//         return "assets/flags/flag_mac.svg";
//       case "MDG":
//         return "assets/flags/flag_mdg.svg";
//       case "MWI":
//         return "assets/flags/flag_mwi.svg";
//       case "MYS":
//         return "assets/flags/flag_mys.svg";
//       case "MDV":
//         return "assets/flags/flag_mdv.svg";
//       case "MLI":
//         return "assets/flags/flag_mli.svg";
//       case "MLT":
//         return "assets/flags/flag_mlt.svg";
//       case "MHL":
//         return "assets/flags/flag_mhl.svg";
//       case "MTQ":
//         return "assets/flags/flag_mtq.svg";
//       case "MRT":
//         return "assets/flags/flag_mrt.svg";
//       case "MUS":
//         return "assets/flags/flag_mus.svg";
//       case "MYT":
//         return "assets/flags/flag_fra.svg";
//       case "CHE":
//         return "assets/flags/flag_che.svg";
//       case "ESP":
//         return "assets/flags/flag_esp.svg";
//       case "GBR":
//         return "assets/flags/flag_gbr.svg";
//       case "NLD":
//         return "assets/flags/flag_nld.svg";
//       case "NOR":
//         return "assets/flags/flag_nor.svg";
//       case "POL":
//         return "assets/flags/flag_pol.svg";
//       case "PRT":
//         return "assets/flags/flag_prt.svg";
//       case "ROU":
//         return "assets/flags/flag_rou.svg";
//       case "SWE":
//         return "assets/flags/flag_swe.svg";
//       case "SVN":
//         return "assets/flags/flag_svn.svg";
//       case "SVK":
//         return "assets/flags/flag_svk.svg";
//       case "TUR":
//         return "assets/flags/flag_tur.svg";
//       case "USA":
//         return "assets/flags/flag_usa.svg";
//       case "ARE":
//         return "assets/flags/flag_are.svg";
//       case "UZB":
//         return "assets/flags/flag_uzb.svg";
//       case "VNM":
//         return "assets/flags/flag_vnm.svg";
//       case "UKR":
//         return "assets/flags/flag_ukr.svg";
//       case "THA":
//         return "assets/flags/flag_tha.svg";
//       case "SGP":
//         return "assets/flags/flag_sgp.svg";
//       case "RUS":
//         return "assets/flags/flag_rus.svg";
//       case "PAK":
//         return "assets/flags/flag_pak.svg";
//       case "NZL":
//         return "assets/flags/flag_nzl.svg";
//       case "LKA":
//         return "assets/flags/flag_lka.svg";
//       case "TWN":
//         return "assets/flags/flag_twn.svg";
//       case "MEX":
//         return "assets/flags/flag_mex.svg";
//       case "MAR":
//         return "assets/flags/flag_mar.svg";
//       case "OMN":
//         return "assets/flags/flag_omn.svg";
//       case "MDA":
//         return "assets/flags/flag_mda.svg";
//       case "MNE":
//         return "assets/flags/flag_mne.svg";
//       case "MKD":
//         return "assets/flags/flag_mkd.svg";
//       case "NGA":
//         return "assets/flags/flag_nga.svg";
//       case "NIC":
//         return "assets/flags/flag_nic.svg";
//       case "PAN":
//         return "assets/flags/flag_pan.svg";
//       case "PER":
//         return "assets/flags/flag_per.svg";
//       case "PRY":
//         return "assets/flags/flag_pry.svg";
//       case "QAT":
//         return "assets/flags/flag_qat.svg";
//       case "REU":
//         return "assets/flags/flag_fra.svg";
//       case "SRB":
//         return "assets/flags/flag_srb.svg";
//       case "SAU":
//         return "assets/flags/flag_sau.svg";
//       case "SYC":
//         return "assets/flags/flag_sey.svg";
//       case "TZA":
//         return "assets/flags/flag_tza.svg";
//       case "UGA":
//         return "assets/flags/flag_uga.svg";
//       case "URY":
//         return "assets/flags/flag_ury.svg";
//       case "ZAF":
//         return "assets/flags/flag_zaf.svg";
//       case "ZMB":
//         return "assets/flags/flag_zmb.svg";
//
//       default:
//         return "assets/flags/ic_globe.svg";
//     }
//   }
// }
