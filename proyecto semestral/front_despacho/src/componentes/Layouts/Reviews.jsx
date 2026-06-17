import React from "react";
import logo1 from "../../assets/images/logo1.png";
import logo2 from "../../assets/images/logo2.png";
import logo3 from "../../assets/images/logo3.png";

function Reviews() {
  return (
    <div className="bg-white  sm:py-10">
      <div className="mx-auto text-center ">
        <h2 className="text-center text-lg font-semibold leading-8 text-gray-900">
          Empresas que confían en nosotros
        </h2>
        <div className="mx-auto mt-10 grid max-w-lg grid-cols-3 items-center gap-x-8 gap-y-10 sm:max-w-xl sm:grid-cols-3 sm:gap-x-10 lg:mx-0 lg:max-w-none lg:grid-cols-3">
          <div className="flex justify-center">
            <img
              className="col-span-2 max-h-16 w-auto object-contain lg:col-span-1 mx-auto"
              src={logo1}
              alt="Logo 1"
            />
          </div>

          <div className="flex justify-center">
            <img
              className="col-span-2 max-h-16 w-auto object-contain lg:col-span-1 mx-auto"
              src={logo2}
              alt="Logo 2"
            />
          </div>

          <div className="flex justify-center">
            <img
              className="col-span-2 max-h-16 w-auto object-contain lg:col-span-1 mx-auto"
              src={logo3}
              alt="Logo 3"
            />
          </div>
        </div>
      </div>
    </div>
  );
}

export default Reviews;
