﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ВидыУведомленийДляИП() Экспорт
	Возврат УведомлениеОСпецрежимахНалогообложенияПовтИсп.ВидыУведомленийДляИП();
КонецФункции

Функция ВидыУведомленийДляОрганизации() Экспорт
	Возврат УведомлениеОСпецрежимахНалогообложенияПовтИсп.ВидыУведомленийДляОрганизации();
КонецФункции

Функция ПолучитьИмяОтчетаПоВидуУведомления(Вид) Экспорт 
	Возврат УведомлениеОСпецрежимахНалогообложенияПовтИсп.ПолучитьСоответствиеВидовУведомленийИменамОтчетов()[Вид];
КонецФункции

Функция ЭтоУведомлениеВФНС(Вид) Экспорт
	Возврат (УведомлениеОСпецрежимахНалогообложенияПовтИсп.ВидыУведомленийВФНС()[Вид] = Истина);
КонецФункции
#КонецЕсли
