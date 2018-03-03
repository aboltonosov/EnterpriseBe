﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии ИБ"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура ЗаполнитьАналитикуНаСчетах вызывается для заполнения аналитики на счетах,
// в соответствии со спецификой конфигурации - потребителя.
//
Процедура ЗаполнитьАналитикуНаСчетах() Экспорт
	
	// Установим субконто на счетах в соответствии с параметрами учета.
	ПараметрыУчета = ОбщегоНазначенияБПКлиентСервер.СтруктураПараметровУчета();
	ПараметрыУчета.ВестиПартионныйУчет					 = Ложь;
	ПараметрыУчета.СкладскойУчет						 = 2;
	ПараметрыУчета.ИспользоватьОборотнуюНоменклатуру	 = Ложь;
	ПараметрыУчета.РазделятьПоСтавкамНДС				 = Ложь;
	ПараметрыУчета.ВестиУчетПоСтатьямДДС				 = Истина;
	ПараметрыУчета.ВестиУчетПоРаботникам				 = Истина;
	ПараметрыУчета.УчетЗарплатыИКадровВоВнешнейПрограмме = Ложь;
	
	ОбщегоНазначенияБПВызовСервера.ПрименитьПараметрыУчета(ПараметрыУчета, Истина, Ложь, Ложь, Истина);
	
	Документы.ДепонированиеЗарплаты.НастроитьАналитикуПоДепонированнойЗарплате();
	
КонецПроцедуры

// Процедура ЗаполнитьРегистрыСчетовУчета заполняет настройки 
// для подстановки счетов учета по умолчанию.
// 
Процедура ЗаполнитьСчетаУчетаПоУмолчанию() Экспорт

КонецПроцедуры

// Установка субконто "Документы расчетов с контрагентами" на счетах расчетов (60, 62, 76).
//
Процедура УстановитьУчетПоДокументамНаСчетахРасчетов() Экспорт

	// В УП2 не используется субконто "Документы расчетов" на счетах взаиморасчетов с контрагентами.

КонецПроцедуры

// Устанавливает аналитику на счетах расчетов с персоналом по оплате труда.
//
Процедура УстановитьУчетПоРаботникам() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка

		// БУ.
		Счета = Новый СписокЗначений();
		Счета.Добавить("РасчетыПоДепонированнымСуммам");
		Счета.Добавить("РасходыНаОплатуТрудаБудущихПериодов");
		
		Для каждого Счет Из Счета Цикл
			ОбновлениеИнформационнойБазыБП.ПрименитьПараметрыРасчетовССотрудниками(Счет.Значение, "Хозрасчетный", Истина)
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();

	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Ошибка при установке учета по работникам'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Процедура обновления ИБ для справочника видов контактной информации.
//
// Инструкция:
// Для каждого объекта, владельца КИ, для каждого соответствующего ему вида КИ добавить 
// строчку вида: УправлениеКонтактнойИнформацией.ОбновитьВидКИ(.....). При этом,
// важен порядок в котором будут осуществляться эти вызовы, чем раньше вызов для вида КИ,
// тем выше этот вид КИ будет располагаться на форме объекта.
//
// Параметры функции УправлениеКонтактнойИнформацией.ОбновитьВидКИ:
// 1. Вид КИ - Ссылка на предопределенный вид КИ.
// 2. Тип КИ - Ссылка на перечисление
// 3. МожноИзменятьСпособРедактирования  - Определяет, можно ли в режиме Предприятие изменить способ редактирования,
//                                         например, для адресов, которые попадают в регл. отчетность, нужно
//                                         запретить возможность изменения.
// 4. РедактированиеТолькоВДиалоге       - Если установить Истина, то будет значение вида КИ можно будет
//                                         редактировать только в форме ввода (имеет смысл только для
//                                         адресов, телефонов и факсов).
// 5. АдресТолькоРоссийский              - Если установить Истина, то для адресов можно будет ввести 
//                                         только российский адрес (имеет смысл только для адресов).
// 6. Порядок                            - Определяет порядок элемента, для сортировки относительно других.
//
//
Процедура КонтактнаяИнформацияОбновлениеИБ() Экспорт

КонецПроцедуры

// Возвращает строку с именем о библиотеке или основной конфигурации.
//
// Возвращаемое значение:
//	Строка - Имя подсистемы в рамках конфигурации.
//
Функция ИмяПодсистемы() Экспорт

	Возврат "РегламентированныйУчет";

КонецФункции

// Заполняет данные предопределенных элементов справочника ВидыРегистровУчета.
// 
Процедура ЗаполнитьВидыРегистровУчета() Экспорт

	// Справки расчеты
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетАмортизации.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетАмортизации);
	ВидРегистра.ВариантОтчета = "Амортизация";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетНалогаНаПрибыль.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетНалогаНаПрибыль);
	ВидРегистра.ВариантОтчета = "РасчетНалогаНаПрибыль";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетПересчетСтоимостиОтложенныхНалоговыхАктивовИОбязательств.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетПересчетСтоимостиОтложенныхНалоговыхАктивовИОбязательств);
	ВидРегистра.ВариантОтчета = "СправкаРасчетПостоянныхИВременныхРазниц";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетПостоянныхИВременныхРазниц.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетПостоянныхИВременныхРазниц);
	ВидРегистра.ВариантОтчета = "СправкаРасчетПостоянныхИВременныхРазниц";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетРезервыПоСомнительнымДолгам.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетРезервыПоСомнительнымДолгам);
	ВидРегистра.ВариантОтчета = "СомнительныеДолги";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетТранспортныхРасходов.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетТранспортныхРасходов);
	ВидРегистра.ВариантОтчета = "ТранспортныеРасходы";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетНалогаНаИмущество.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетНалогаНаИмущество);
	ВидРегистра.ВариантОтчета = "РасчетНалогаНаИмущество";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетПризнаниеРасходовПоОСПоступившимВЛизинг.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетПризнаниеРасходовПоОСПоступившимВЛизинг);
	ВидРегистра.ВариантОтчета = "ПризнаниеРасходовПоОСПоступившимВЛизинг";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
КонецПроцедуры

#КонецОбласти
