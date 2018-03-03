﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//       Может использоваться для получения настроек варианта этого отчета при помощи функции ВариантыОтчетов.ОписаниеВарианта().
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки этого отчета,
//       уже сформированные при помощи функции ВариантыОтчетов.ОписаниеОтчета() и готовые к изменению.
//       См. "Свойства для изменения" процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ПодсистемаЗарплата = Метаданные.НайтиПоПолномуИмени("Подсистема.Зарплата.Подсистема.ВыплатыПеречисления");
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КнигаУчетаДепонентов");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("ИспользоватьНачислениеЗарплаты");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Истина;
	ОписаниеВарианта.ГруппироватьПоОтчету = Ложь;
	ОписаниеВарианта.Размещение.Очистить();
	ОписаниеВарианта.Размещение.Вставить(ПодсистемаЗарплата);
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализДепонированнойЗарплаты");
	ОписаниеВарианта.Описание = НСтр("ru= 'Состояние расчетов организации с депонентами: перечень депонентов на начало,
	|образовавшиеся депоненты, месяца выплаты для каждого депонента.'");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("ИспользоватьНачислениеЗарплаты");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Ложь;
	ОписаниеВарианта.ГруппироватьПоОтчету = Ложь;
	ОписаниеВарианта.Размещение.Очистить();
	ОписаниеВарианта.Размещение.Вставить(ПодсистемаЗарплата);
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокДепонентов");
	ОписаниеВарианта.Описание = НСтр("ru= 'Сводный список депонированных сумм и выплат по сотрудникам организации.'");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("ИспользоватьНачислениеЗарплаты");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Ложь;
	ОписаниеВарианта.ГруппироватьПоОтчету = Ложь;
	ОписаниеВарианта.Размещение.Очистить();
	ОписаниеВарианта.Размещение.Вставить(ПодсистемаЗарплата);
	
	ПодсистемаРегл = Метаданные.НайтиПоПолномуИмени("Подсистема.РегламентированныйУчет.Подсистема.БухгалтерскийУчет");
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КнигаУчетаДепонентовРегл");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("НеИспользоватьРасчетЗарплатыРасширенная");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Истина;
	ОписаниеВарианта.ГруппироватьПоОтчету = Ложь;
	ОписаниеВарианта.Размещение.Очистить();
	ОписаниеВарианта.Размещение.Вставить(ПодсистемаРегл);
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализДепонированнойЗарплатыРегл");
	ОписаниеВарианта.Описание = НСтр("ru= 'Состояние расчетов организации с депонентами: перечень депонентов на начало,
	|образовавшиеся депоненты, месяца выплаты для каждого депонента.'");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("НеИспользоватьРасчетЗарплатыРасширенная");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Ложь;
	ОписаниеВарианта.ГруппироватьПоОтчету = Ложь;
	ОписаниеВарианта.Размещение.Очистить();
	ОписаниеВарианта.Размещение.Вставить(ПодсистемаРегл);
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокДепонентовРегл");
	ОписаниеВарианта.Описание = НСтр("ru= 'Сводный список депонированных сумм и выплат по сотрудникам организации.'");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("НеИспользоватьРасчетЗарплатыРасширенная");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Ложь;
	ОписаниеВарианта.ГруппироватьПоОтчету = Ложь;
	ОписаниеВарианта.Размещение.Очистить();
	ОписаниеВарианта.Размещение.Вставить(ПодсистемаРегл);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли