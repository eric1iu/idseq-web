import React from "react";
import PropTypes from "prop-types";
import { forbidExtraProps } from "airbnb-prop-types";

const IconDownloadSmall = ({ className }) => {
  return (
    <svg className={className} width="14px" height="14px" viewBox="0 0 14 14">
      <g strokeWidth="1" fillRule="evenodd">
        <path d="M7.00991123,0.8 C7.24373772,0.79758799 7.46878563,0.891801182 7.63380879,1.06157895 C7.79954967,1.23209512 7.89054024,1.46425334 7.88562756,1.70486695 L7.88558588,7.04166095 L8.85950035,5.90823195 C9.06428247,5.66543715 9.3787237,5.55460975 9.68415802,5.61596595 C9.99020465,5.67744516 10.2407844,5.90249 10.3395033,6.20577295 C10.3903643,6.36202766 10.3967887,6.52640402 10.3624416,6.68145095 C10.3299229,6.82824444 10.260858,6.96667501 10.1583573,7.08193395 L7.66722698,9.98103495 C7.50312052,10.1704762 7.26684949,10.27907 7.01891922,10.27907 C6.77098895,10.27907 6.53471791,10.1704761 6.37008788,9.98042795 L3.88172257,7.08449795 C3.65962287,6.83749333 3.59140331,6.48923033 3.70220314,6.17797795 C3.81264164,5.86774061 4.08233616,5.64639282 4.40161829,5.60265595 C4.69332392,5.56263188 4.98519468,5.67668004 5.17643675,5.90598595 L6.15225255,7.04166095 L6.15225255,1.70894895 C6.14736427,1.46746133 6.23588556,1.23814381 6.39769856,1.06816395 C6.53196495,0.927121013 6.70740331,0.836671672 6.89567314,0.809010953 L7.00991123,0.8 Z M11.7963204,8.90636934 C11.3254754,8.96105724 10.96,9.36121243 10.96,9.84672897 L10.959,11.118 L3.042,11.118 L3.04345794,9.84676237 C3.04345794,9.323865 2.61959295,8.9 2.09672897,8.9 C1.573865,8.9 1.15,9.323865 1.15,9.84672897 L1.15,12 L1.15018855,12.0589072 C1.15,12.5879091 1.573865,13.0117741 2.09672897,13.0117741 L11.903271,13.0117741 C12.3887876,13.0117741 12.7889428,12.6462987 12.8436307,12.1754537 L12.8515345,12.0195191 L12.8534579,9.84672897 C12.8534579,9.323865 12.4295929,8.9 11.906729,8.9 L11.7963204,8.90636934 Z" />
      </g>
    </svg>
  );
};

IconDownloadSmall.propTypes = forbidExtraProps({
  className: PropTypes.string,
});

export default IconDownloadSmall;
