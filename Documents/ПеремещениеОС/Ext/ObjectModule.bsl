﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура") И ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
		ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения.ДокументОснование);
	КонецЕсли;
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ИнвентаризацияОС") Тогда
		ОбработкаЗаполненияИнвентаризацияОС(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеВнеоборотнымиАктивамиПереопределяемый.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперацииРеглУчет.ПеремещениеОС Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ОрганизацияПолучатель");
		
	КонецЕсли;
	
	ПроверяемыеРеквизитыСтатейРасходов = "";
	
	Если НачислениеАмортизации = 1 Тогда
		ПроверяемыеРеквизитыСтатейРасходов = ПроверяемыеРеквизитыСтатейРасходов + ", СтатьяРасходов, АналитикаРасходов";
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходов");
	КонецЕсли;
	
	Если ИзменяетсяОтражениеРасходовПоНалогу Тогда
		ПроверяемыеРеквизитыСтатейРасходов = ПроверяемыеРеквизитыСтатейРасходов + ", СтатьяРасходовНалог, АналитикаРасходовНалог";
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовНалог");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходовНалог");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПроверяемыеРеквизитыСтатейРасходов) Тогда
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
			ЭтотОбъект,
			Сред(ПроверяемыеРеквизитыСтатейРасходов, 3),
			МассивНепроверяемыхРеквизитов,
			Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РассчитатьАмортизацию(Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ОчиститьЗаписатьДвижения(Движения, "Хозрасчетный");
	
	ТаблицаРеквизитов = ТаблицаРеквизитовДокумента();
	
	УчетОСВызовСервера.ПроверитьСоответствиеОСОрганизации(
		ОС.Выгрузить(),
		ТаблицаРеквизитов,
		Отказ);
	
	УчетОСВызовСервера.ПроверитьСостояниеОСПринятоКУчету(
		ОС.Выгрузить(),
		ТаблицаРеквизитов,
		Отказ);
	
	УчетОСВызовСервера.ПроверитьСоответствиеМестонахожденияОС(
		ОС.Выгрузить(),
		ТаблицаРеквизитов,
		Отказ);
	
	УчетОСВызовСервера.ПроверитьЗаполнениеСчетаУчетаОС(
		ОС.Выгрузить(),
		ТаблицаРеквизитов,
		Отказ);
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ПеремещениеОС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РеглУчетПроведениеСервер.ОтразитьПорядокОтраженияПрочихОпераций(ДополнительныеСвойства, Отказ);
	ДополнительныеСвойства.ТаблицыДляДвижений.Удалить("ПорядокОтраженияПрочихОпераций");
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	ДополнительныеСвойства.ТаблицыДляДвижений.Удалить("ОтражениеДокументовВРеглУчете");
	
	Для Каждого ТаблицаДвижений Из ДополнительныеСвойства.ТаблицыДляДвижений Цикл
		ПроведениеСерверУТ.ОтразитьДвижения(ТаблицаДвижений.Значение, Движения[ТаблицаДвижений.Ключ], Отказ);
	КонецЦикла;
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	СформироватьЗаданияКЗакрытиюМесяца();
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	Если Не Отказ Тогда
		РеглУчетПроведениеСервер.ОтразитьДокумент(Новый Структура("Ссылка, Дата, Организация", Ссылка, Дата));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	СформироватьЗаданияКЗакрытиюМесяца();
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	ДокументНаОсновании = ЗначениеЗаполнено(ДокументОснование);
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если Не ЗначениеЗаполнено(СобытиеОС) Тогда
		СобытиеОС = УчетОСВызовСервера.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.ВнутреннееПеремещение);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполненияИнвентаризацияОС(Знач ДанныеЗаполнения)
	
	ДокументОснование = Неопределено;
	МассивНомеровСтрок = Неопределено;
	СообщатьОбОшибках = Истина;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ДокументОснование = ДанныеЗаполнения.ДокументОснование;
		МассивНомеровСтрок = ДанныеЗаполнения.МассивНомеровСтрок;
		СообщатьОбОшибках = ДанныеЗаполнения.СообщатьОбОшибках;
	Иначе
		ДокументОснование = ДанныеЗаполнения;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	РезультатЗапроса = Документы.ИнвентаризацияОС.ДанныеЗаполненияДокументовНаОсновании(ДокументОснование, "Перемещение", МассивНомеровСтрок);
	Если РезультатЗапроса.ТабличнаяЧасть = Неопределено Или РезультатЗапроса.ТабличнаяЧасть.Пустой() Тогда
		Если СообщатьОбОшибках Тогда
			ТекстОшибки = НСтр("ru='В документе %1 отсутствуют строки требующие заполнения перемещения'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, ДокументОснование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.ДокументОснование");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Реквизиты.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	Выборка = РезультатЗапроса.ТабличнаяЧасть.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ЗначениеЗаполнено(Подразделение) Тогда
			Подразделение = Выборка.УчетПодразделение;
			ПодразделениеПолучатель = Выборка.Подразделение;
		КонецЕсли;
		Если Выборка.УчетПодразделение = Подразделение
			И Выборка.Подразделение = ПодразделениеПолучатель Тогда
			
			ЗаполнитьЗначенияСвойств(ОС.Добавить(), Выборка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Новый Массив);
	
КонецПроцедуры

Функция ТаблицаРеквизитовДокумента()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	&Ссылка КАК Регистратор,
		|	&Дата КАК Период,
		|	НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) КАК ДатаРасчета,
		|	&Номер,
		|	&Организация,
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету) КАК СостояниеОС,
		|	""ОС"" КАК ИмяСписка,
		|	ИСТИНА КАК ВыдаватьСообщения,
		|	&Подразделение КАК Подразделение,
		|	&МОЛ КАК МОЛ");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Номер", Номер);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("МОЛ", МОЛ);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура РассчитатьАмортизацию(Отказ)
	
	НачисленнаяАмортизация.Очистить();
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперацииРеглУчет.ПеремещениеОС
		И Подразделение = ПодразделениеПолучатель Тогда
		
		ТаблицаНачисленнаяАмортизация = УчетОСВызовСервера.ПустаяТаблицаЗначенийНачисленнойАмортизации();
	Иначе
		ТаблицаНачисленнаяАмортизация = УчетОСВызовСервера.НачисленнаяАмортизация(
			ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство"), ТаблицаРеквизитовДокумента(), Отказ);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("НачисленнаяАмортизация", ТаблицаНачисленнаяАмортизация);
	НачисленнаяАмортизация.Загрузить(ТаблицаНачисленнаяАмортизация);
	
КонецПроцедуры

Процедура СформироватьЗаданияКЗакрытиюМесяца()

	ДанныеТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	РасчетИмущественныхНалоговПереопределяемый.СформироватьЗаданиеКРасчетуНалогаНаИмущество(ДанныеТаблиц);
	РасчетИмущественныхНалоговПереопределяемый.СформироватьЗаданиеКРасчетуТранспортногоНалога(ДанныеТаблиц);
	РасчетИмущественныхНалоговПереопределяемый.СформироватьЗаданиеКРасчетуЗемельногоНалога(ДанныеТаблиц);
	УчетОСВызовСервера.СформироватьЗаданиеАмортизацияОС(ДанныеТаблиц);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли