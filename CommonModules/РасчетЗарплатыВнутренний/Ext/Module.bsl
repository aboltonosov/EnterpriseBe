﻿
#Область СлужебныйПрограммныйИнтерфейс

// Заполняет движения плановыми начислениями.
//
Процедура СформироватьДвиженияПлановыхНачислений(РегистраторОбъект, Движения, СтруктураДанных, ФормироватьЗаписиТолькоДляИзменений, ЗаполнятьНаборЗаписей) Экспорт
	
	РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений(РегистраторОбъект, Движения, СтруктураДанных, ФормироватьЗаписиТолькоДляИзменений, ЗаполнятьНаборЗаписей);
	
КонецПроцедуры

// Заполняет движения плановыми выплатами (авансы).
//
// Параметры:
//	Движения - коллекция движений, в которой необходимо заполнить движения.
//	ДанныеОПлановыхВыплатах - таблица значений с полями:
//		ДатаСобытия
//		ВидСобытия - Перечисление.ВидыКадровыхСобытий
//		ДействуетДо (не обязательно).
//		Сотрудник
//		Аванс
// 		
Процедура СформироватьДвиженияПлановыхВыплат(Движения, ДанныеОПлановыхВыплатах) Экспорт

	РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхВыплат(Движения, ДанныеОПлановыхВыплатах);
	
КонецПроцедуры

// Заполняет движения плановыми удержаниями.
//
// Параметры:
//		Движения
//		СтруктураДанных - Структура с ключами:
//			* ДанныеПлановыхУдержаний - таблица значений с колонками.
//				* ДатаСобытия.
//				* ДействуетДо (необязательно).
//				* ФизическоеЛицо.
//				* Организация
//				* Удержание
//				* ДокументОснование (необязательно).
//				* Используется
//				* ИспользуетсяПоОкончании (необязательно).
//			* ЗначенияПоказателей - таблица значений с колонками (необязательный).
//				* ДатаСобытия
//				* ДействуетДо (необязательно).
//				* ФизическоеЛицо.
//				* Организация
//				* ДокументОснование (необязательно).
//				* Показатель
//				* Значение
//
Процедура СформироватьДвиженияПлановыхУдержаний(Движения, СтруктураДанных) Экспорт

	РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхУдержаний(Движения, СтруктураДанных);
	
КонецПроцедуры

Процедура ПодобратьДокументНачисленияЗарплаты(ДокументСсылка, МесяцНачисления, Организация, Подразделение = Неопределено) Экспорт
	РасчетЗарплатыБазовый.ПодобратьДокументНачисленияЗарплаты(ДокументСсылка, МесяцНачисления, Организация, Подразделение);
КонецПроцедуры

Функция ОснованиеИсчисленияНалогаСОтсроченнойУплатой(Основания) Экспорт

	Возврат РасчетЗарплатыРасширенный.ОснованиеИсчисленияНалогаСОтсроченнойУплатой(Основания)	

КонецФункции 

// Составляет структуру данных, содержащую в себе коллекции результатов начисления зарплаты за указанный месяц.
//
Функция РезультатНачисленияРасчетаЗарплаты(Организация, ДатаНачала, ДатаОкончания, МесяцНачисления, Документ, Подразделение, Сотрудники) Экспорт
	Возврат РасчетЗарплатыБазовый.РезультатНачисленияРасчетаЗарплаты(Организация, ДатаНачала, ДатаОкончания, МесяцНачисления, Документ, Подразделение, Сотрудники);
КонецФункции

// Конструирует объект для хранения данных для проведения.
// Структура может содержать
//		НачисленияПоСотрудникам - таблица значений
//			ФизическоеЛицо.
//			Сотрудник
//			Подразделение
//			Начисление
//			Сумма
//			ОтработаноДней
//			ОтработаноЧасов
//
//		УдержанияПоСотрудникам - таблица значений
//			ФизическоеЛицо.
//			Удержание
//			Сумма
//
//		ИсчисленныйНДФЛ - таблица значений.
//
//		ИсчисленныеВзносы - таблица значений.
//
//		МенеджерВременныхТаблиц - менеджер временных таблиц на котором могут 
//		удерживаться таблицы
//			ВТНачисления (данные о начисленных суммах).
//				Сотрудник
//				ПериодДействия
//				ДатаНачала
//				Начисление
//				СуммаДохода
//				СуммаВычетаНДФЛ
//				СуммаВычетаВзносы
//				КодВычетаНДФЛ
//				Подразделение
//			ВТФизическиеЛица (список людей по которым выполняется расчет)
//				ФизическоеЛицо.
//
Функция СоздатьДанныеДляПроведенияНачисленияЗарплаты() Экспорт
	Возврат РасчетЗарплатыРасширенный.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
КонецФункции

// Формирует данные для проведения документа по регистру расчета Начисления.
//
Процедура ЗаполнитьНачисления(ДанныеДляПроведения, Документ, ТаблицаНачислений, ПолеДатыДействия, ПолеВидаНачисления = Неопределено, ПолеВидаНачисленияВШапке = Неопределено, ФизическиеЛица = Неопределено) Экспорт
	РасчетЗарплатыРасширенный.ЗаполнитьНачисления(ДанныеДляПроведения, Документ, ТаблицаНачислений, ПолеДатыДействия, ПолеВидаНачисления);
КонецПроцедуры

// Заполняет данные для проведения удержаниями.
//	
// Параметры:	
// 		ДанныеДляПроведенияНачисленияЗарплаты.
//		Документ
//		ТаблицаУдержаний - имя табличной части с удержаниями, не обязательно, по умолчанию - "Удержания".
//
Процедура ЗаполнитьУдержания(ДанныеДляПроведенияНачисленияЗарплаты, Документ, ТаблицаУдержаний = "Удержания", ФизическиеЛица = Неопределено) Экспорт
	РасчетЗарплатыРасширенный.ЗаполнитьУдержания(ДанныеДляПроведенияНачисленияЗарплаты, Документ, ТаблицаУдержаний);
КонецПроцедуры

// Дополняет структуру данных для проведения таблицей НДФЛ.
//
Процедура ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, ДокументСсылка, ФизическиеЛица = Неопределено) Экспорт
	РасчетЗарплатыРасширенный.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, ДокументСсылка, ФизическиеЛица);
КонецПроцедуры

// Дополняет структуру данных для проведения таблицей страховых взносов.
//
Процедура ЗаполнитьДанныеСтраховыхВзносов(ДанныеДляПроведения, ДокументСсылка, ФизическиеЛица) Экспорт
	РасчетЗарплатыРасширенный.ЗаполнитьДанныеСтраховыхВзносов(ДанныеДляПроведения, ДокументСсылка, ФизическиеЛица);
КонецПроцедуры

// Возвращает таблицу значений с колонками
//	ФизическоеЛицо.
//	Сотрудник
//	Подразделение
//	Сумма
//
// Параметры:
//	ФизическиеЛица
//	МесяцНачисления
//
Функция ПолучитьБазуУдержанийПоУмолчанию(ФизическиеЛица, МесяцНачисления, Организация) Экспорт
	Возврат РасчетЗарплатыРасширенный.БазаУдержанийПоУмолчанию(ФизическиеЛица, МесяцНачисления, Организация);
КонецФункции

// Выполняет создание начислений и удержаний по настройкам расчета зарплаты.
//
Процедура СформироватьПланВидовРасчетаПоНастройкам(НачальноеЗаполнение = Ложь) Экспорт
	РасчетЗарплатыРасширенный.СформироватьПланВидовРасчетаПоНастройкам(Неопределено, НачальноеЗаполнение);
КонецПроцедуры

// Создает начислений районного коэффициента и северной надбавки в зависимости от установленных настроек.
//
Процедура СформироватьВидыРасчетаРКиСН() Экспорт
	РасчетЗарплатыРасширенный.СформироватьВидыРасчетаРКиСН();
КонецПроцедуры

// Создает временную таблицу ВТПорядокПредопределенныхНачисленийУдержаний.
// Используется при первоначальном заполнении ИБ, для заполнения реквизита РеквизитДопУпорядочивания.
//	Поля
//		Ссылка - ссылка, ПланыВидовРасчета.Начисления, ПланыВидовРасчета.Удержания
//		Порядок - число
//		НачислениеУдержание - строка, "Начисление" или "Удержание".
// 
Процедура СоздатьВТПорядокПредопределенныхНачисленийУдержаний(МенеджерВременныхТаблиц, ТолькоРазрешенные) Экспорт
	РасчетЗарплатыРасширенный.СоздатьВТПорядокПредопределенныхНачисленийУдержаний(МенеджерВременныхТаблиц, ТолькоРазрешенные);
КонецПроцедуры

// Формирует временную таблицу ВТДополнительныеСвойстваНачислений с полями
// Начисление - ПланВидовРасчетаСсылка.Начисления
// ЯвляетсяДенежнымСодержанием, Булево
// ЯвляетсяДенежнымДовольствием, Булево
//
Процедура СоздатьВТДополнительныеСвойстваНачислений(МенеджерВременныхТаблиц) Экспорт
	РасчетЗарплатыРасширенный.СоздатьВТДополнительныеСвойстваНачислений(МенеджерВременныхТаблиц);			
КонецПроцедуры

// Составляет структуру данных, содержащую в себе коллекции результатов начисления зарплаты за указанный месяц.
//
Процедура ЗаполнитьДокументНачисленияЗарплаты(ДанныеНачисленияЗарплаты) Экспорт
	РасчетЗарплатыБазовый.ЗаполнитьДокументНачисленияЗарплаты(ДанныеНачисленияЗарплаты);
КонецПроцедуры	

Процедура УстановитьВходимостьНачисленийВБазуРКИСН() Экспорт
	
	// В этой конфигурации ничего не делаем.
	
КонецПроцедуры

Процедура УстановитьСпособРасчетаАвансаСотрудников() Экспорт
	
	// В этой конфигурации ничего не делается.
	
КонецПроцедуры

Процедура СформироватьВидыРасчетаБольничныхОтпусковИсполнительныхЛистов() Экспорт
	
	// В этой конфигурации ничего не делается.
	
КонецПроцедуры

Процедура УстановитьЗачетОтработанногоВремениНачислений() Экспорт
	
	// В этой конфигурации ничего не делается
	
КонецПроцедуры

Процедура ЗаполнитьОтработанноеВремяОтсутствий() Экспорт
	
	// В этой конфигурации ничего не делается
	
КонецПроцедуры

Процедура ЗаполнитьДатуНачалаРегистраНакопленияОтработанноеВремяПоСотрудникам() Экспорт
	
	РасчетЗарплатыРасширенный.ЗаполнитьДатуНачалаРегистраНакопленияОтработанноеВремяПоСотрудникам();
	
КонецПроцедуры

Процедура ЗаполнитьПланируемыеДатыВыплатыОтпусковИБольничныхЛистов() Экспорт
	
	// В этой конфигурации ничего не делаем
	
КонецПроцедуры

#Область КорректировкиВыплаты

Процедура ФормаПодробнееОРасчетеНДФЛПриЗаполнении(Форма) Экспорт
	РасчетЗарплатыРасширенныйФормы.ФормаПодробнееОРасчетеНДФЛПриЗаполнении(Форма);
КонецПроцедуры

// Дополняет структуру данных для проведения таблицей КорректировкиВыплаты.
//
Процедура ЗаполнитьДанныеКорректировкиВыплаты(ДанныеДляПроведения, ДокументСсылка, ФизическиеЛица = Неопределено) Экспорт
	РасчетЗарплатыРасширенный.ЗаполнитьДанныеКорректировкиВыплаты(ДанныеДляПроведения, ДокументСсылка, ФизическиеЛица);
КонецПроцедуры

Процедура ЗаполнитьТаблицыКорректировкиВыплаты() Экспорт
	РасчетЗарплатыРасширенный.ЗаполнитьТаблицыКорректировкиВыплаты();
КонецПроцедуры

Функция КонтролируемыеПоляКорректировкиВыплатыДляФиксацииРезультатов() Экспорт
	Возврат РасчетЗарплатыРасширенныйФормы.КонтролируемыеПоляКорректировкиВыплатыДляФиксацииРезультатов();
КонецФункции

Функция РезультатРаспределенияКорректировкиВыплаты(РаспределениеРезультатовУдержаний, ИдентификаторСтроки) Экспорт
	Возврат РасчетЗарплатыРасширенныйФормы.РезультатРаспределенияКорректировкиВыплаты(РаспределениеРезультатовУдержаний, ИдентификаторСтроки);
КонецФункции

#КонецОбласти

Процедура ЗаполнитьДатыВыплатыВНачисленияхЗарплаты(ПараметрыОбновления = НеОпределено) Экспорт
	
	// В этой конфигурации ничего не делается
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
	
КонецПроцедуры

Функция ИзмеренияРасчетаПлановыхНачислений() Экспорт
	
	Возврат РасчетЗарплатыРасширенный.ИзмеренияРасчетаПлановыхНачислений();
	
КонецФункции

Процедура ЗаполнитьИдентификаторыСтрокВРегистрахНакопления(ПараметрыОбновления) Экспорт
	
	РасчетЗарплатыРасширенный.ЗаполнитьИдентификаторыСтрокВРегистрахНакопления(ПараметрыОбновления);
	
КонецПроцедуры

Процедура ЗаполнитьГоловныеОрганизацииПлановыхАвансов(ПараметрыОбновления) Экспорт
	
	РасчетЗарплатыРасширенный.ЗаполнитьГоловныеОрганизацииПлановыхАвансов(ПараметрыОбновления);
	
КонецПроцедуры

Функция ЗначениеПоказателяПоИдентификатору(Показатели, Идентификатор) Экспорт
	
	Возврат РасчетЗарплатыРасширенный.ЗначениеПоказателяПоИдентификатору(Показатели, Идентификатор);
	
КонецФункции

Функция НачисленияТарифнойСтавки() Экспорт
	
	Возврат РасчетЗарплатыРасширенный.НачисленияТарифнойСтавки();
	
КонецФункции

Функция КатегорииСдельнойОплатыТруда() Экспорт
	
	Возврат РасчетЗарплатыРасширенный.КатегорииСдельнойОплатыТруда();
	
КонецФункции

Функция КатегорииНачисленийКомпенсационныхВыплат() Экспорт
	
	Возврат РасчетЗарплатыРасширенный.КатегорииНачисленийКомпенсационныхВыплат();
	
КонецФункции

#КонецОбласти
